# frozen_string_literal: true

module OtpHelper
  def totp(otp_secret)
    ROTP::TOTP.new(otp_secret, issuer: "Antrian")
  end

  def generate_otp(orang)
    if orang.otp_locked_at.blank?
      orang.update_columns(otp_request_count: orang.otp_request_count + 1)
    end

    if orang.otp_locked_at.present?
      return false if (Time.zone.now - orang.otp_locked_at) < 24.hours

      orang.update_columns(otp_request_count: 1, otp_locked_at: nil)

    end

    if orang.otp_request_count >= 10 && orang.otp_locked_at.blank?
      orang.update_columns(otp_locked_at: Time.zone.now)
    end

    totp(orang.otp_secret).now
  end

  def verify_otp(orang, otp)
    verify = totp(orang.otp_secret).verify_with_drift(otp, 125)
    orang.update(otp_request_count: 0, otp_locked_at: nil) if verify

    verify
  end
end
