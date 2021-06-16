function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit.productionready.io/api/'
  }

  if (env == 'dev') {
    config.userEmail = 'dagmara.weso@gmail.com'
    config.userPassword = 'dagaokakao'
  } 
  
  else if (env == 'qa') {
    config.userEmail = 'dagmara.weso1@gmail.com'
    config.userPassword = 'dagaokakao1'
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}