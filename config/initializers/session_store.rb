Rails.application.config.session_store :active_record_store, key: (Rails.env.production? ? '_fitness-for-students_session_id' : (Rails.env.demo? ? '_fitness-for-students_demo_session_id' : '_fitness-for-students_dev_session_id')),
                                                             secure: (Rails.env.demo? || Rails.env.production?),
                                                             httponly: true
