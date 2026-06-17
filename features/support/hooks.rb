Before('@limpar_sessao') do
  Capybara.reset_sessions!
end

After do |cenario|
  if cenario.failed?
    nome = cenario.name.gsub(/[^a-z0-9]/i, '_').downcase
    caminho = "tmp/screenshots/#{nome}_#{Time.now.strftime('%Y%m%d_%H%M%S')}.png"
    if page.respond_to?(:save_screenshot) && Capybara.current_driver != :rack_test
      FileUtils.mkdir_p("tmp/screenshots")
      page.save_screenshot(caminho)
      attach(File.read(caminho), "image/png")
    end
  end
end
