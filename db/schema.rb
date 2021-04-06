# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_25_044243) do

  create_table "exchange_confirms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "memo"
    t.string "status"
    t.integer "exchange_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exchange_imp_imgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tag"
    t.string "name"
    t.binary "file", limit: 16777215
    t.string "content_type"
    t.integer "exchange_id"
  end

  create_table "exchanges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.integer "pt"
    t.integer "actual_money"
    t.string "phone"
    t.string "account_holder"
    t.string "bank"
    t.string "account_number"
    t.integer "user_id"
    t.integer "point_history_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "img_url"
    t.string "post_type"
    t.date "start_date"
    t.date "end_date"
    t.integer "event_id"
  end

  create_table "owner_comment_confirms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "memo"
    t.string "status"
    t.integer "owner_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owner_comment_imgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tag"
    t.string "name"
    t.binary "file", limit: 16777215
    t.string "content_type"
    t.integer "owner_comment_id"
  end

  create_table "owner_comment_imp_imgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tag"
    t.string "name"
    t.binary "file", limit: 16777215
    t.string "content_type"
    t.integer "owner_comment_id"
  end

  create_table "owner_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "long", precision: 10, scale: 6
    t.string "address"
    t.string "detail_address"
    t.string "extra_address"
    t.string "bd_nm"
    t.string "si_nm"
    t.string "sgg_nm"
    t.string "emd_nm"
    t.string "room"
    t.string "hidden_camera"
    t.string "contact_time"
    t.string "contact_method", default: "--- []\n"
    t.text "long_term_txt"
    t.date "remodeling_date"
    t.text "remodeling_txt"
    t.text "intro_txt"
    t.integer "user_id"
    t.integer "original_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "point_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "pt"
    t.string "memo"
    t.integer "review_id"
    t.integer "user_id"
    t.integer "point_id"
    t.integer "exchange_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "points", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "pt"
    t.date "exp_date"
    t.integer "user_id"
  end

  create_table "recently_contracts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "contract_type"
    t.float "suply_prvuse_ar"
    t.date "compet_de"
    t.string "floor"
    t.float "rent_gtn"
    t.float "mt_rntchrg"
    t.integer "review_id"
  end

  create_table "req_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "si_nm"
    t.string "sgg_nm"
    t.string "emd_nm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "req_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "content"
    t.string "address"
    t.string "password_digest"
    t.string "client_ip"
    t.integer "req_address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "review_confirms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "memo"
    t.string "status"
    t.integer "review_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirm_type"
  end

  create_table "review_imgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tag"
    t.string "name"
    t.binary "file", limit: 16777215
    t.string "content_type"
    t.integer "review_item_id"
    t.integer "review_id"
  end

  create_table "review_imp_imgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tag"
    t.string "name"
    t.binary "file", limit: 16777215
    t.string "content_type"
    t.integer "review_id"
  end

  create_table "review_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tag"
    t.integer "score"
    t.text "comment"
    t.integer "review_id"
  end

  create_table "review_videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "tag"
    t.string "name"
    t.binary "file", limit: 4294967295
    t.string "content_type"
    t.integer "review_item_id"
    t.integer "review_id"
  end

  create_table "reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "editable", default: "t", null: false
    t.string "main_img_name"
    t.binary "main_img", limit: 16777215
    t.string "main_img_content_type"
    t.string "status"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "long", precision: 10, scale: 6
    t.string "address"
    t.string "detail_address"
    t.string "extra_address"
    t.string "bd_nm"
    t.string "si_nm"
    t.string "sgg_nm"
    t.string "emd_nm"
    t.string "room"
    t.integer "start_year"
    t.integer "end_year"
    t.string "floor"
    t.string "loan_1"
    t.string "pet"
    t.string "is_recommend"
    t.text "hourly_seasonal_txt"
    t.string "short_comment"
    t.text "long_comment"
    t.integer "user_id"
    t.integer "original_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "third_party_imp", default: "f"
    t.string "imp_status", default: "완료"
    t.integer "deposit", default: 0
    t.integer "monthly", default: 0
    t.string "contract_type", default: ""
    t.integer "management_fee"
    t.string "management_type", default: "--- []\n"
    t.integer "parking", default: -1
    t.float "area_pyeong"
    t.float "area_square"
    t.string "structure", default: ""
    t.string "usage", default: ""
    t.string "floor_detail", default: ""
    t.date "start_date"
    t.date "end_date"
    t.string "elevator"
    t.string "balcony"
    t.string "is_rental_house", default: "f"
    t.string "instt_nm"
    t.date "compet_de"
    t.integer "hshld_co"
    t.string "suply_ty_nm"
    t.string "house_ty_nm"
    t.string "heat_mthd_detail_nm"
    t.string "buld_stle_nm"
    t.string "elvtr_instl_at_nm"
    t.integer "parkng_co"
    t.string "style_nm", default: "--- []\n"
    t.string "suply_prvuse_ar", default: "--- []\n"
    t.string "suply_cmnuse_ar", default: "--- []\n"
    t.string "bass_rent_gtn", default: "--- []\n"
    t.string "bass_mt_rntchrg", default: "--- []\n"
    t.string "bass_cnvrs_gtn_lmt", default: "--- []\n"
    t.date "contract_date"
  end

  create_table "sec_viewer_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "viewer_count"
    t.string "memo"
    t.datetime "date_of_use"
    t.integer "user_id"
    t.integer "review_id"
    t.integer "sec_viewer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sec_viewers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "viewer_type", default: "구매"
    t.string "receipt_url"
    t.integer "item_type"
    t.integer "item_price"
    t.integer "item_count"
    t.integer "price"
    t.integer "count"
    t.string "merchant_uid"
    t.string "imp_uid"
    t.date "exp_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "free"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "role", default: "user", null: false
    t.string "name"
    t.string "merchant_uid"
    t.string "imp_uid"
    t.string "is_promotion", default: "f", null: false
    t.string "histories", default: "--- []\n"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "viewer_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "viewer_count"
    t.string "memo"
    t.datetime "date_of_use"
    t.integer "user_id"
    t.integer "review_id"
    t.integer "viewer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "viewers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "viewer_type", default: "구매"
    t.string "receipt_url"
    t.integer "item_type"
    t.integer "item_price"
    t.integer "item_count"
    t.integer "price"
    t.integer "count"
    t.string "merchant_uid"
    t.string "imp_uid"
    t.date "exp_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "free"
  end

end
