require "test_helper"

class GuestTest < ActiveSupport::TestCase
  test "requires a well formed email" do
    guest = Guest.new(name: "Ana", email: "not-an-email")

    assert_not guest.valid?
    assert_includes guest.errors[:email], "is invalid"
  end

  test "treats emails as case insensitive" do
    create_guest(email: "ana@example.com")

    duplicate = Guest.new(name: "Outra Ana", email: "ANA@Example.com")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "normalises the email before saving" do
    guest = Guest.create!(name: "Ana", email: "  ANA@Example.COM ")

    assert_equal "ana@example.com", guest.email
  end
end
