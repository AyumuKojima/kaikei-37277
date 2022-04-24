function categoryDelete () {
  const deleteBtn = document.getElementById("category-delete-btn");
  deleteBtn.addEventListener('click', () => {
    const showList = document.getElementById("show-list");
    const destroyMessage = document.getElementById("destroy-message");
    const subContents = document.getElementById("sub-contents");

    showList.setAttribute('class', "show-list hidden");
    destroyMessage.setAttribute('class', "destroy-message");
    subContents.setAttribute('class', "sub-contents hidden");
  });
};

window.addEventListener('turbolinks:load', categoryDelete)