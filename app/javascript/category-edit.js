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
    const nameForm = document.getElementById("category-name-form");
    const colorForm = document.getElementById("category-color-form");
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
};

window.addEventListener('turbolinks:load', editCategory);