import { initializeApp } from 'firebase/app';
import { getAuth, GoogleAuthProvider, signInWithPopup } from 'firebase/auth';

const firebaseConfig = {
  apiKey: "AIzaSyBsKdM9PnR-5yRul-CZHxs3H3eBVMXUe20",
  authDomain: "cloud-kitchen-c2ff0.firebaseapp.com",
  projectId: "cloud-kitchen-c2ff0",
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const provider = new GoogleAuthProvider();
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

window.signInWithGoogle = function() {
  signInWithPopup(auth, provider)
    .then((result) => {
      const user = result.user;
      const idToken = user.stsTokenManager.accessToken;
      fetch("/auth/google_login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken
        },
        body: JSON.stringify({ idToken: user.stsTokenManager.accessToken }),
      })
      .then(response => response.json())
      .then(data => {
        console.log('Response Data:', data);
        if (data.success) {
          window.location.href = "/";
        } else {
          alert("Login failed");
        }
      });
    })
    .catch((error) => {
      console.error("Error signing in with Google:", error);
    });
}
