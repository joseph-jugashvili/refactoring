class MoneyOperation
  include InputHelper

  def initialize(database, account)
    @database = database
    @account = account
    @card_operation = CardOperation.new(database, account)
  end

  def withdraw_money_operation
    card = @card_operation.select_card(I18n.t('request.card_withdrawing'))
    return if card.nil?

    amount = acquire_withdraw_amount(card)
    return if amount.nil?

    withdraw_money(card, amount)
  end

  def put_money_operation
    card = @card_operation.select_card(I18n.t('request.card_putting'))
    return if card.nil?

    amount = acquire_put_amount(card)
    return if amount.nil?

    put_money(card, amount)
  end

  def send_money_operation
    sender_card = @card_operation.select_card(I18n.t('request.card_send'), I18n.t('request.correct_card'))
    return if sender_card.nil?

    recipient_card = @card_operation.search_recipient_card
    return if recipient_card.nil?

    amount = acquire_send_amount(sender_card, recipient_card)
    send_money(sender_card, recipient_card, amount)
  end

  private

  def put_money(card, amount)
    card.put_money(amount)
    @database.update_database
    puts I18n.t('notification.put_money', amount: amount, card_number: card.card_number,
                                          balance: card.balance, tax: card.put_tax(amount))
  end

  def withdraw_money(card, amount)
    card.money_left(amount)
    @database.update_database
    puts I18n.t('notification.withdraw_money', amount: amount, card_number: card.card_number,
                                               balance: card.balance, tax: card.withdraw_tax(amount))
  end

  def send_money(sender_card, recipient_card, amount)
    sender_card.send_money(amount)
    recipient_card.put_money(amount)
    @database.update_database
    puts I18n.t('notification.put_money', amount: amount, card_number: sender_card.card_number,
                                          balance: recipient_card.balance, tax: sender_card.put_tax(amount))
    puts I18n.t('notification.put_money', amount: amount, card_number: recipient_card.card_number,
                                          balance: sender_card.balance, tax: sender_card.sender_tax(amount))
  end

  def acquire_withdraw_amount(card)
    amount = acquire_amount(I18n.t('input.amount_withdraw'))
    return unless available_withdraw_amount?(amount, card)

    amount
  end

  def acquire_put_amount(card)
    amount = acquire_amount(I18n.t('input.amount_put'))
    return unless available_put_amount?(amount, card)

    amount
  end

  def acquire_send_amount(sender_card, recipient_card)
    loop do
      amount = acquire_amount(I18n.t('input.amount_withdraw'))
      next unless available_send_amount?(amount, sender_card, recipient_card)

      return amount
    end
  end

  def available_put_amount?(amount, card)
    return false unless validate_amount?(amount, I18n.t('notification.correct_amount_two'))
    return true if card.put_available?(amount)

    puts I18n.t('notification.higher_tax')
    false
  end

  def available_withdraw_amount?(amount, card)
    return false unless validate_amount?(amount, I18n.t('notification.correct_amount_one'))
    return true if card.withdraw_available?(amount)

    puts I18n.t('notification.no_enough_money')
    false
  end

  def available_send_amount?(amount, sender_card, recipient_card)
    validations = [validate_amount?(amount, I18n.t('notification.wrong_number')),
                   validate_send_money?(amount, sender_card),
                   validate_put_money?(amount, recipient_card)]
    validations.all? ? true : false
  end

  def validate_send_money?(amount, sender_card)
    return true if sender_card.send_money?(amount)

    puts I18n.t('notification.no_enough_money_on_sender_card')
    false
  end

  def validate_put_money?(amount, recipient_card)
    return true if recipient_card.put_money?(amount)

    puts I18n.t('notification.no_enough_money_on_sender_card')
    false
  end

  def validate_amount?(amount, notice_text)
    return true if amount.positive?

    puts notice_text
    false
  end
end
