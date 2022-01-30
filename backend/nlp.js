const { NlpManager, ConversationContext } = require('node-nlp');

const nlp = new NlpManager({ languages: ['en'] });
const context = new ConversationContext();

(async () => {

  let genres = ['rap', 'jazz', 'anime', 'classical', 'rock', 'pop', 'indie', 'bollywood']

  for(let i=0; i<genres; i++){
    nlp.addNamedEntityText(
      'genre',
      genres[i],
      ['en'],
      [genres[i]],
    );
  }

  // Adds the utterances and intents for the NLP
  nlp.addDocument('en', 'hello', 'greetings.hello');
  nlp.addDocument('en', 'hi', 'greetings.hello');
  nlp.addDocument('en', 'howdy', 'greetings.hello');
  nlp.addDocument('en', 'hola', 'greetings.hello');

  nlp.addDocument('en', 'bye', 'greetings.bye');
  nlp.addDocument('en', 'sayonara', 'greetings.bye');
  nlp.addDocument('en', 'goodbye', 'greetings.bye');
  nlp.addDocument('en', 'see you', 'greetings.bye');

  nlp.addDocument('en', 'how are you', 'greetings.inquire');
  nlp.addDocument('en', 'how are you doing', 'greetings.inquire');
  nlp.addDocument('en', 'how is you', 'greetings.inquire');

  nlp.addDocument('en', 'thanks', 'greetings.thanks');
  nlp.addDocument('en', 'thank you', 'greetings.thanks');

  nlp.addDocument('en', 'play some music', 'actions.music');
  nlp.addDocument('en', 'play music', 'actions.music');
  nlp.addDocument('en', 'play songs', 'actions.music');
  nlp.addDocument('en', 'play songs on spotify', 'actions.music');

  nlp.addDocument('en', 'send an email to %email%', 'actions.email');
  nlp.addDocument('en', 'call %phonenumber%', 'actions.call');
  nlp.addDocument('en', 'message %phonenumber%', 'actions.sms');
  nlp.addDocument('en', 'sms %phonenumber%', 'actions.sms');
  nlp.addDocument('en', 'open %url%', 'actions.openurl');
  nlp.addDocument('en', 'open %url%', 'actions.openurl');
  

  nlp.addAnswer('en', 'greetings.bye', 'Goodbye! Looking forward to talking to you again');
  nlp.addAnswer('en', 'greetings.bye', 'See you soon!');

  nlp.addAnswer('en', 'greetings.inquire', 'I\'m doing great!');

  nlp.addAnswer('en', 'greetings.thanks', 'You are welcome! :D');
  nlp.addAnswer('en', 'greetings.thanks', 'You\'re welcome!');
  nlp.addAnswer('en', 'greetings.thanks', 'Anytime, {{name}}!');

  nlp.addAnswer('en', 'greetings.hello', 'Hey {{name}}!',);
  nlp.addAnswer('en', 'greetings.hello', 'Hola {{name}}!');  
  await nlp.train();
})();

module.exports = (input, callback) => {
  nlp.process(input).then(out => {
    let res = {
      input: input,
      intent: out.intent,
      score: out.score,
      entities: [],
      answer: out.answer,
      success: true
    }
    if(out.entities != null) {
      res.entities = out.entities.map(x => {
        return {
          type: x.entity,
          value: x.resolution.value
        }
      })
    }
    callback(res)
  })
}