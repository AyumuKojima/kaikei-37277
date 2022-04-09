function formColor () {
  const selector = document.getElementById("category-color-form");
  const colors = document.querySelectorAll(".color");
  const newCategory = document.getElementById("new-category");
  const newCategoryName = document.getElementById("new-category-name");
  const categoryNameForm = document.getElementById("category-name-form");
  const categoryColorForm = document.getElementById("category-color-form");
  const categoryInputBtn = document.getElementById("category-input-btn");
  const num = selector.value;
  const rgb = colors[num].innerHTML;
  newCategory.setAttribute("style", `border-color: rgb${rgb};`);
  newCategoryName.setAttribute("style", `color: rgb${rgb};`);
  categoryNameForm.setAttribute("style", `border-color: rgb${rgb};`);
  categoryColorForm.setAttribute("style", `border-color: rgb${rgb};`);
  categoryInputBtn.setAttribute("style", `background-color: rgb${rgb};`);

  selector.addEventListener("change",() => {
    const num = selector.value;
    const rgb = colors[num].innerHTML;
    newCategory.setAttribute("style", `border-color: rgb${rgb};`);
    newCategoryName.setAttribute("style", `color: rgb${rgb};`);
    categoryNameForm.setAttribute("style", `border-color: rgb${rgb};`);
    categoryColorForm.setAttribute("style", `border-color: rgb${rgb};`);
    categoryInputBtn.setAttribute("style", `background-color: rgb${rgb};`);
  });
};

window.addEventListener("turbolinks:load", formColor);