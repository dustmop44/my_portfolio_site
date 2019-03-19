Rails.application.routes.draw do
  get '/', to: 'homepage#home', as: "root"
  get 'download_resume', to: 'homepage#download_resume'
  get '*path' => redirect('/')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
