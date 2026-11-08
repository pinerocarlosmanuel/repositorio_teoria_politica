require "test_helper"

class EnlaceTest < ActiveSupport::TestCase
  test "validaciones obligatorias" do
    enlace = Enlace.new
    assert_not enlace.valid?
    assert enlace.errors[:titulo].any?
    assert enlace.errors[:url].any?
    assert enlace.errors[:seccion].any?
  end

  test "url debe ser http/https" do
    enlace = enlaces(:enlace_cia)
    enlace.url = "no-es-una-url"
    assert_not enlace.valid?
  end

  test "url válida" do
    assert enlaces(:enlace_cia).valid?
  end
end
