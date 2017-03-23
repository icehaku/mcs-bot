Rails.application.routes.draw do
	post '/webhooks/telegram_XY9wMhL0M9Y0B2DBt0H22HFd01969KaB', to: 'telegram#callback'
	get '/webhooks/telegram_XY9wMhL0M9Y0B2DBt0H22HFd01969KaB', to: 'telegram#callback'
end
