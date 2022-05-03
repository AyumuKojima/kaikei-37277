class AjaxRequestCounter {

  static start() {
    const _this = new AjaxRequestCounter()
    window.pendingRequestCount = 0
    document.addEventListener('ajax:send', _this)
    document.addEventListener('ajax:complete', _this)
  }

  handleEvent(event) {
    switch(event.type) {
      case 'ajax:send':
        pendingRequestCount++
        break

      case 'ajax:complete':
        pendingRequestCount--
        break
    }
  }
}

export { AjaxRequestCounter }