class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token  # Skip CSRF verification for webhooks

  def razorpay
    webhook_body = request.raw_post
    webhook_signature = request.headers['x-razorpay-signature']
    webhook_secret = Rails.application.credentials.razorpay[:webhook_secret]  # Store your webhook secret securely

    begin
      Razorpay::Utility.verify_webhook_signature(webhook_body, webhook_signature, webhook_secret)
      
      # Handle the webhook event here
      handle_event(JSON.parse(webhook_body))

      head :ok  # Respond with 200 OK
    rescue SecurityError
      head :unauthorized  # Respond with 401 Unauthorized
    rescue JSON::ParserError
      head :bad_request  # Respond with 400 Bad Request if JSON parsing fails
    end
  end

  private

  def handle_event(event)
    # Handle different events (e.g., payment.authorized, payment.captured)
    case event['event']

    when 'order.paid'
      order_id = event['payload']['order']['entity']['id']
      order = Order.find_by(razor_order_id: order_id)
      order.payment_verified! if order
      
    when 'payment.authorized'
      # Handle payment authorized event
    when 'payment.captured'
      # Handle payment captured event
      payment_id = event['payload']['payment']['entity']['id']
      order = Order.find_by(razorpay_payment_id: payment_id)
      order.payment_verified! if order
    else
      Rails.logger.info "Unhandled event: #{event['event']}"
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
