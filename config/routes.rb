Rails.application.routes.draw do
  devise_for :users

  # Fase 0: inicio
  root "home#index"
  get "buscar", to: "home#buscar"

  # Fase 1: M1 Conceptos + M2 Documentación
  resources :temas
  resources :conceptos do
    resources :enlace_conceptos, only: :create
    member { get :descargar }
  end
  resources :enlace_conceptos, only: :destroy
  resources :documentos do
    member { get :descargar }
  end

  # Fase 2: M3 Sistemas reutilizable
  resources :paises do
    resources :sistemas, shallow: true do
      resources :particularidades, shallow: true do
        resources :variables, shallow: true do
          resources :indicadores, shallow: true
        end
      end
    end
  end
  get "cuba", to: "paises#cuba"
  get "comparativa", to: "paises#comparativa"

  # Catálogo histórico de tipos de sistemas de gobierno (página "Sistemas")
  get "sistemas", to: "sistemas_gobierno#index"
  resources :sistemas_gobierno do
    resources :enlace_sistema_gobiernos, only: :create
  end
  resources :enlace_sistema_gobiernos, only: :destroy

  # Fase 3: M4 Asistente local + M5 Recursos didácticos
  resources :chat, only: :index do
    collection do
      post :consultar
      get  :historial
    end
  end
  resources :reglas
  resources :chat_logs
  get "analisis", to: "analisis#index"
  get "analisis/comparar", to: "analisis#comparar", as: :analisis_comparar
  resources :recursos_didacticos do
    member { get :descargar }
  end
  resources :referencias

  # Fase 6: Páginas institucionales y módulo Teoría de la conspiración
  get "acerca", to: "secciones#acerca"
  get "teoria_de_la_conspiracion", to: "secciones#teoria_conspiracion"
  resources :secciones
  resources :enlaces

  # Panel de administración y configuración general del sitio
  get "administracion", to: "admin#index"
  get "configuraciones", to: "configuraciones#index"
  patch "configuraciones", to: "configuraciones#update"

  # Gestión de usuarios desde la pestaña "Usuarios"
  post "configuraciones/usuarios", to: "configuraciones#crear_usuario", as: :configuraciones_usuarios
  patch "configuraciones/usuarios/:id", to: "configuraciones#actualizar_usuario", as: :configuracion_usuario
  delete "configuraciones/usuarios/:id", to: "configuraciones#eliminar_usuario"

  # Importador CSV (admin)
  namespace :imports do
    get  :index
    post :conceptos
    post :paises
  end

  # API JSON mínima (lectura)
  namespace :api do
    namespace :v1 do
      resources :conceptos, only: %i[index show]
      resources :documentos, only: :index
      resources :paises, only: :index
      resources :recursos_didacticos, only: :index
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "manifest.json", to: "pwa#manifest", as: :pwa_manifest
end
