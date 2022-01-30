const db = require("./database");
const bcrypt = require("bcryptjs");
var jwt = require('jsonwebtoken');
const { v4: uuid } = require('uuid');

async function register(email, password){
    let previous = await db().collection('users').findOne({ email: email });
    if(previous != null) {
        return {
            success: false,
            message: 'That email is already in use.'
        }
    }

    let data = {
        uuid: uuid(),
        email: email,
        password: bcrypt.hashSync(password, 8),
        creation_timestamp: Date.now(),
        interests: [],
        one_time_password: null,
        completed_profile: false,
        full_name: '',
        age: 18,
        sex: -1,
        reminders: [],
        spotify_access_token: null,
        spotify_refresh_token: null,
        twitter_token: null,
        twitter_secret: null,
        profile_picture: null
    };

    data.access_token = jwt.sign({ uuid: data.uuid }, process.env.JWT_SECRET);

    await db().collection('users').insertOne(data);

    return {
        success: true,
        message: 'User was created successfully',
        access_token: data.access_token
    }
}

async function login(email, password){
    let previous = await db().collection('users').findOne({ email: email });
    if(previous == null) {
        return {
            success: false,
            message: 'No account is associated with that email.'
        }
    }

    let isCorrect = bcrypt.compareSync(password, previous.password);

    if(!isCorrect)
        return {
            success: false,
            message: 'Wrong Password'
        } 

    let access_token = jwt.sign({ uuid: previous.uuid }, process.env.JWT_SECRET);

    await db().collection('users').updateOne({ uuid: previous.uuid }, { $set: { access_token: access_token }});

    return {
        success: true,
        message: 'Successfully logged in',
        access_token: access_token
    }
}

async function updateInterests(access_token, interests) {
    const validInterests = ['music','movies','shows','fitness','anime',
        'programming','travelling','architecture','sports','memes'];

    interests = interests.filter(i => validInterests.includes(i))

    await db().collection('users').updateOne({ access_token: access_token }, 
        { $set: { interests: interests }});

    return {
        success: true,
        message: 'Successfully updated interests'
    }
}

async function updateProfile(access_token, full_name, age, sex, profile_picture) {
    let updates = {};

    if(full_name != null) updates.full_name = full_name;
    if(age != null) updates.age = age;
    if(sex != null) updates.sex = sex;
    if(profile_picture != null) updates.profile_picture = profile_picture;

    await db().collection('users').updateOne({ access_token: access_token }, 
        { $set: updates});

    return {
        success: true,
        message: 'Successfully updated profile'
    }
}

async function verifyToken(token){
    let previous = await db().collection('users').findOne({ access_token: token });
    if(previous == null) {
        return {
            success: false,
            message: 'Invalid access token'
        }
    }
    return {
        success: true,
        access_token: token
    }
}

async function getUserData(token){
    let previous = await db().collection('users').findOne({ access_token: token });
    if(previous == null) {
        return {
            success: false,
            message: 'Invalid access token'
        }
    }

    let data = {
        full_name: previous.full_name,
        age: previous.age,
        sex: previous.sex,
        uuid: previous.uuid,
        email: previous.email,
        interests: previous.interests,
        reminders: previous.reminders,
        spotify_access_token: previous.spotify_access_token,
        spotify_refresh_token: previous.spotify_refresh_token,
        profile_picture: previous.profile_picture
    };

    return {
        success: true,
        user_data: data
    }
}

async function authenticate(req, res, next) {
    let previous = await db().collection('users').findOne({ access_token: req.body.access_token });
    if(previous == null) {
        return res.status(401).send({
            success: false,
            message: 'Invalid access token'
        }) 
    }
    next()
}

module.exports = {
    register,
    login,
    verifyToken,
    updateInterests,
    updateProfile,
    authenticate,
    getUserData
};