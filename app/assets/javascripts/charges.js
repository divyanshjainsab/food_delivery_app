var stripe = Stripe('pk_test_51QnIA7GD8EaTh3oHGa11bBSBaJFEyjrDg9FpMbYdHtDiOwcPoGH4WClUTXMw5vT3TXitOgS1IxqeovO0Mil8g3Rh00qbU0Ph9o'); // public key
var elements = stripe.elements();

var style = {
  base: {
    color: '#32325d',
    fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
    fontSmoothing: 'antialiased',
    fontSize: '16px',
    '::placeholder': {
      color: '#aab7c4'
    }
  },
  invalid: {
    color: '#fa755a',
    iconColor: '#fa755a'
  }
};

var card = elements.create('card', { style: style });
card.mount('#card-element');

card.on('change', function(event) {
  var displayError = document.getElementById('card-errors');
  if (event.error) {
    displayError.textContent = event.error.message;
  } else {
    displayError.textContent = '';
  }
});
