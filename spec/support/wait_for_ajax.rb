module WaitForAjax
  def wait_for_ajax(wait_time = Capybara.default_max_wait_time)
    Timeout.timeout(wait_time) do
      loop until finished_all_ajax_requiests?
    end
    yield if block_given?
  end

  def finished_all_ajax_requiests?
    page.evaluate_script('window.pendingRequestCount').zero?
  end
end