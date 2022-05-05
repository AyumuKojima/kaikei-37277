function categoryDelete () {
  const deleteBtn = document.getElementById("category-delete-btn");
  deleteBtn.addEventListener('click', () => {
    const showList = document.getElementById("show-list");
    const destroyMessageBox = document.getElementById("destroy-message-box");
    const subContents = document.getElementById("sub-contents");
    const categoryBtns = document.querySelector(".category-btns");

    showList.setAttribute('class', "show-list hidden");
    destroyMessageBox.setAttribute('class', "destroy-message-box");
    subContents.setAttribute('class', "sub-contents hidden");
    categoryBtns.setAttribute('style', 'display: none;');
  });
};

window.addEventListener('turbolinks:load', categoryDelete)