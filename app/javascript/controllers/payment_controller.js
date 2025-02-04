import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payment"
export default class extends Controller {
  connect() {
    console.log("Payment controller connected");
  }

  getCookieByName(name) {
    const match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
    if (match) {
        return match[2];
    }
    return null;
  } 

  redirectToCheckout(event) {
    event.preventDefault();  // Prevent the default button action

    if (this.getCookieByName("role") === null){}
      window.location.href = "/authentication/new";

    const dishId = event.currentTarget.getAttribute('data-redirect-dish-id');  

    if (dishId) {
      console.log(`Fetching session URL for dish with ID: ${dishId}`);

      // Make a request to the server to get the session URL
      fetch(`/payments`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,  // CSRF token
        },
        body: JSON.stringify({
          id: dishId
        })
      })
      .then(response => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();  // Parse JSON response
      })
      .then(data => {
        const sessionUrl = data.session_url;
        console.log("Session URL received:", sessionUrl);

        // Redirect the user to the session URL
        if (sessionUrl) {
          window.location.href = sessionUrl;  // Redirect to the Stripe checkout session
        } else {
          console.error("Session URL is missing!");
        }
      })
      .catch(error => {
        console.error("Error fetching session URL:", error);
      });
    } else {
      console.error("Dish ID is missing!");
    }
  }
}
