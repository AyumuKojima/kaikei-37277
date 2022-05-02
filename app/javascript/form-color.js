function formColor () {
  const colors = document.querySelectorAll(".color");
  const newCategory = document.getElementById("new-category");
  const newCategoryName = document.getElementById("new-category-name");
  const categoryNameForm = document.getElementById("title");
  const categoryColorForm = document.getElementById("color_id");
  const categoryInputBtn = document.getElementById("category-input-btn");
  const num = categoryColorForm.value;
  const rgb = colors[num].innerHTML;
  newCategory.setAttribute("style", `border-color: rgb${rgb};`);
  newCategoryName.setAttribute("style", `color: rgb${rgb};`);
  categoryNameForm.setAttribute("style", `border-color: rgb${rgb};`);
  categoryColorForm.setAttribute("style", `border-color: rgb${rgb};`);
  categoryInputBtn.setAttribute("style", `background-color: rgb${rgb};`);

  categoryColorForm.addEventListener("change",() => {
    const num = categoryColorForm.value;
    const rgb = colors[num].innerHTML;
    newCategory.setAttribute("style", `border-color: rgb${rgb};`);
    newCategoryName.setAttribute("style", `color: rgb${rgb};`);
    categoryNameForm.setAttribute("style", `border-color: rgb${rgb};`);
    categoryColorForm.setAttribute("style", `border-color: rgb${rgb};`);
    categoryInputBtn.setAttribute("style", `background-color: rgb${rgb};`);
  });
};

window.addEventListener("turbolinks:load", formColor);