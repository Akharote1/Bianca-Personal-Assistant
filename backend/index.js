require('dotenv').config();

const express = require('express')
const app = express()
const { body, validationResult } = require('express-validator');

const db = require('./db/database');
const user = require('./db/user');
const nlp = require('./nlp');

app.use(express.json());

const port = 8092;

app.get('/', (req, res) => {
    res.send('Test')
})

app.post('/sign-up', 
    body('email').isEmail().toLowerCase().trim(),
    body('password').isLength({ min: 8, max: 32 }).matches(/^[a-zA-Z0-9*.$%^&@#?~!/\\]+$/),
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ 
                errors: errors.array(),
                success: false
            });
        }
        user.register(req.body.email, req.body.password).then(result => {
            let status = result.success ? 200 : 400;
            res.status(status).send(result);
        });
    })

app.post('/login', 
    body('email').isEmail().toLowerCase().trim(),
    body('password').isLength({ min: 8, max: 32 }).matches(/^[a-zA-Z0-9*.$%^&@#?~!/\\]+$/),
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ 
                errors: errors.array(),
                success: false
            });
        }
        user.login(req.body.email, req.body.password).then(result => {
            let status = result.success ? 200 : 400;
            res.status(status).send(result);
        });
    })

app.post('/update-interests', 
    body('access_token').isJWT(),
    body('interests').isArray(),
    user.authenticate,
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ 
                errors: errors.array(),
                success: false
            });
        }
        user.updateInterests(req.body.access_token, req.body.interests).then(result => {
            let status = result.success ? 200 : 400;
            res.status(status).send(result);
        });
    })

app.post('/update-profile', 
    body('access_token').optional().isJWT(),
    body('full_name').optional().isString().isLength({ min: 2, max: 30 }),
    body('age').optional().isNumeric({ min: 5, max: 130}),
    body('sex').optional().isNumeric({ min: -1, max: 2}),
    body('profile_picture').optional().isURL(),
    user.authenticate,
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ 
                errors: errors.array(),
                success: false
            });
        }
        user.updateProfile(
                req.body.access_token, 
                req.body.full_name,
                req.body.age,
                req.body.sex,
                req.body.profile_picture
            ).then(result => {
                let status = result.success ? 200 : 400;
                res.status(status).send(result);
            });
    })

app.post('/verify-token', 
    body('access_token').isJWT(),
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ 
                errors: errors.array(),
                success: false
            });
        }
        user.verifyToken(req.body.access_token).then(result => {
            let status = result.success ? 200 : 400;
            res.status(status).send(result);
        });
    })

app.post('/user-data', 
    body('access_token').isJWT(),
    (req, res) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ 
                errors: errors.array(),
                success: false
            });
        }
        user.getUserData(req.body.access_token).then(result => {
            let status = result.success ? 200 : 400;
            res.status(status).send(result);
        });
    })

app.get('/chat', 
    (req, res) => {
        if(req.query.message == null){
            return res.status(400).send({success: false})
        }
        nlp(req.query.message, (out)=>{
            res.status(200).send(out)
        })
    })

app.listen(port, () => {
  console.log(`Bianca server listening on port ${port}`)
})


/*
    To anyone reading, I know the code is a mess. 
    Let's just say, so was our time management during the hackathon.
*/