function editCategory () {
  const editBtn = document.getElementById("category-edit-btn");
  editBtn.addEventListener("click", () => {
    const editCategoryForm = document.getElementById("new-category");
    const spendForm = document.getElementById("spend-form");
    const colors = document.querySelectorAll(".color");
    if (editCategoryForm.getAttribute("class") == "new-category hidden") {
      editCategoryForm.setAttribute("class", "new-category");
      spendForm.setAttribute("style", "display: none;");
    };
    const nameForm = document.getElementById("title");
    const colorForm = document.getElementById("color_id");
    const categoryTitle = document.getElementById("category-title").innerHTML;
    const colorId = document.getElementById("color-id").innerHTML;
    const categoryInputBtn = document.getElementById("category-input-btn");
    const newCategoryName = document.getElementById("new-category-name");

    nameForm.value = categoryTitle.trim();
    colorForm.value = colorId;
    const num = colorForm.value;
    const rgb = colors[num].innerHTML;
    editCategoryForm.setAttribute("style", `border-color: rgb${rgb};`);
    newCategoryName.setAttribute("style", `color: rgb${rgb};`);
    nameForm.setAttribute("style", `border-color: rgb${rgb};`);
    colorForm.setAttribute("style", `border-color: rgb${rgb};`);
    categoryInputBtn.setAttribute("style", `background-color: rgb${rgb};`);
  });

  const editCategoryBtn = document.getElementById("post-category-submit");
  if (editBtn != null) {
    editCategoryBtn.addEventListener('click', (e) => {
      e.preventDefault();
      adjustToken();

      const form = document.getElementById("post-category-form");
      const formData = new FormData(form);
      XHR = setUpdateXHR();
      XHR.send(formData);

      XHR.onload = () => {
        if (XHR.status != 200) {
          alert(`Error ${XHR.status}: ${XHR.statusText}`);
          return null;
        } else if (XHR.response.error) {
          setErrorMessages(XHR.response.error_messages);
        } else {
          location.reload();
        };
      };
    });
  };
};

function adjustToken () {
  document.querySelector('input[name="authenticity_token"]').value = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
};

function setUpdateXHR () {
  const year = document.getElementById("display-year").innerHTML;
  const month = document.getElementById("display-month").innerHTML;
  const categoryId = document.getElementById("current-category-id").innerHTML;
  const XHR = new XMLHttpRequest();
  XHR.open('PATCH', `/years/${year}/months/${month}/categories/${categoryId}`);
  XHR.responseType = "json";
  return XHR;
};

function setErrorMessages (errorMessages) {
  err = document.getElementById("category-error-messages");
  for (let i=0; i<errorMessages.length; i++) {
    err.insertAdjacentHTML('beforeend', `<li>${errorMessages[i]}</li>`)
  };
};

window.addEventListener('turbolinks:load', editCategory);