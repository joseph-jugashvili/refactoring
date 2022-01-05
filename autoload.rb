require 'yaml'
require 'i18n'

I18n.config.load_path << Dir[File.expand_path('config/locales').concat('/*.yml')]
I18n.config.available_locales = :en

require_relative 'app/entities/cards/card'
require_relative 'app/entities/cards/usual'
require_relative 'app/entities/cards/capitalist'
require_relative 'app/entities/cards/virtual'
require_relative 'app/helpers/output_helper'
require_relative 'app/helpers/input_helper'
require_relative 'app/validations/account_validator'
require_relative 'app/storage/database/database'
require_relative 'app/entities/account/account'
require_relative 'app/operations/card_operation'
require_relative 'app/operations/money_operation'
require_relative 'app/view/console/console_registration'
require_relative 'app/view/console/console_login'
require_relative 'app/view/console/console'
