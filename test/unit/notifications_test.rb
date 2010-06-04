require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "send_notification_mail" do
    @expected.subject = 'Notifications#send_notification_mail'
    @expected.body    = read_fixture('send_notification_mail')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_send_notification_mail(@expected.date).encoded
  end

  test "forgot_password" do
    @expected.subject = 'Notifications#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_forgot_password(@expected.date).encoded
  end

end
