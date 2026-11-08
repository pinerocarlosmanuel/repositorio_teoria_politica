require "test_helper"

class PwaTest < ActionDispatch::IntegrationTest
  test "el manifest se sirve con la marca MES y sin color rojo" do
    get pwa_manifest_path
    assert_response :success
    json = response.parsed_body
    assert_equal "#1f4e79", json["theme_color"]
    assert_not_includes json["icons"].map { |i| i["src"] }, "red"
    assert json["icons"].any? { |i| i["src"] == "/mes_logo.jpeg" }
  end
end
