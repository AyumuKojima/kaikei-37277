function user_btn () {
  const userBtn = document.getElementById("user-btn")
  const userInfo = document.getElementById("user")
  userBtn.addEventListener('click', function (e) {
    e.preventDefault()
    if (userInfo.getAttribute("style") == "display: block;") {
      userInfo.removeAttribute("style", "display: block;")
    } else {
      userInfo.setAttribute("style", "display: block;")
    };
  });
};

window.addEventListener("turbolinks:load", user_btn);