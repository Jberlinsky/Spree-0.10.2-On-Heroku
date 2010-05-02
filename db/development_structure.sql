CREATE TABLE "addresses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "firstname" varchar(255), "lastname" varchar(255), "address1" varchar(255), "address2" varchar(255), "city" varchar(255), "state_id" integer, "zipcode" varchar(255), "country_id" integer, "phone" varchar(255), "created_at" datetime, "updated_at" datetime, "state_name" varchar(255), "alternative_phone" varchar(255));
CREATE TABLE "adjustments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "order_id" integer, "type" varchar(255), "amount" decimal, "description" varchar(255), "position" integer, "created_at" datetime, "updated_at" datetime, "adjustment_source_id" integer, "adjustment_source_type" varchar(255));
CREATE TABLE "assets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "viewable_id" integer, "viewable_type" varchar(50), "attachment_content_type" varchar(255), "attachment_file_name" varchar(255), "attachment_size" integer, "position" integer, "type" varchar(75), "attachment_updated_at" datetime, "attachment_width" integer, "attachment_height" integer);
CREATE TABLE "calculators" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "type" varchar(255), "calculable_id" integer NOT NULL, "calculable_type" varchar(255) NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "checkouts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "order_id" integer, "email" varchar(255), "ip_address" varchar(255), "special_instructions" text, "bill_address_id" integer, "created_at" datetime, "updated_at" datetime, "state" varchar(255), "ship_address_id" integer, "shipping_method_id" integer);
CREATE TABLE "configurations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime, "type" varchar(50));
CREATE TABLE "countries" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "iso_name" varchar(255), "iso" varchar(255), "name" varchar(255), "iso3" varchar(255), "numcode" integer);
CREATE TABLE "coupons" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "code" varchar(255), "description" varchar(255), "usage_limit" integer, "combine" boolean, "expires_at" datetime, "created_at" datetime, "updated_at" datetime, "starts_at" datetime);
CREATE TABLE "creditcards" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "number" text, "month" varchar(255), "year" varchar(255), "verification_value" text, "cc_type" varchar(255), "last_digits" varchar(255), "first_name" varchar(255), "last_name" varchar(255), "created_at" datetime, "updated_at" datetime, "start_month" varchar(255), "start_year" varchar(255), "issue_number" varchar(255), "address_id" integer, "gateway_customer_profile_id" varchar(255), "gateway_payment_profile_id" varchar(255));
CREATE TABLE "gateways" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "type" varchar(255), "name" varchar(255), "description" text, "active" boolean DEFAULT 't', "environment" varchar(255) DEFAULT 'development', "server" varchar(255) DEFAULT 'test', "test_mode" boolean DEFAULT 't', "created_at" datetime, "updated_at" datetime);
CREATE TABLE "inventory_units" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "variant_id" integer, "order_id" integer, "state" varchar(255), "lock_version" integer DEFAULT 0, "created_at" datetime, "updated_at" datetime, "shipment_id" integer, "return_authorization_id" integer);
CREATE TABLE "line_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "order_id" integer, "variant_id" integer, "quantity" integer NOT NULL, "price" decimal(8,2) NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "open_id_authentication_associations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "issued" integer, "lifetime" integer, "handle" varchar(255), "assoc_type" varchar(255), "server_url" blob, "secret" blob);
CREATE TABLE "open_id_authentication_nonces" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "timestamp" integer NOT NULL, "server_url" varchar(255), "salt" varchar(255) NOT NULL);
CREATE TABLE "option_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(100), "presentation" varchar(100), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "option_types_prototypes" ("prototype_id" integer, "option_type_id" integer);
CREATE TABLE "option_values" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "option_type_id" integer, "name" varchar(255), "position" integer, "presentation" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "option_values_variants" ("variant_id" integer, "option_value_id" integer);
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "number" varchar(15), "item_total" decimal(8,2) DEFAULT 0.0 NOT NULL, "total" decimal(8,2) DEFAULT 0.0 NOT NULL, "created_at" datetime, "updated_at" datetime, "state" varchar(255), "token" varchar(255), "adjustment_total" decimal(8,2) DEFAULT 0.0 NOT NULL, "credit_total" decimal(8,2) DEFAULT 0.0 NOT NULL, "completed_at" datetime);
CREATE TABLE "payment_methods" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "type" varchar(255), "name" varchar(255), "description" text, "active" boolean DEFAULT 't', "environment" varchar(255) DEFAULT 'development', "created_at" datetime, "updated_at" datetime, "deleted_at" datetime DEFAULT NULL);
CREATE TABLE "payments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "payable_id" integer, "created_at" datetime, "updated_at" datetime, "amount" decimal DEFAULT 0.0 NOT NULL, "payable_type" varchar(255), "source_id" integer, "source_type" varchar(255), "payment_method_id" integer);
CREATE TABLE "preferences" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "attribute" varchar(100) NOT NULL, "owner_id" integer(30) NOT NULL, "owner_type" varchar(50) NOT NULL, "group_id" integer, "group_type" varchar(50), "value" text(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "product_groups" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "permalink" varchar(255), "order" varchar(255));
CREATE TABLE "product_groups_products" ("product_id" integer, "product_group_id" integer);
CREATE TABLE "product_option_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "product_id" integer, "option_type_id" integer, "position" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "product_properties" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "product_id" integer, "property_id" integer, "value" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "product_scopes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "product_group_id" integer, "name" varchar(255), "arguments" text);
CREATE TABLE "products" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) DEFAULT '' NOT NULL, "description" text, "created_at" datetime, "updated_at" datetime, "permalink" varchar(255), "available_on" datetime, "tax_category_id" integer, "shipping_category_id" integer, "deleted_at" datetime, "meta_description" varchar(255), "meta_keywords" varchar(255), "count_on_hand" integer DEFAULT 0 NOT NULL);
CREATE TABLE "products_taxons" ("product_id" integer, "taxon_id" integer);
CREATE TABLE "properties" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "presentation" varchar(255) NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "properties_prototypes" ("prototype_id" integer, "property_id" integer);
CREATE TABLE "prototypes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "queued_mails" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "object" text, "mailer" varchar(255));
CREATE TABLE "return_authorizations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "number" varchar(255), "amount" decimal(8,2) DEFAULT 0.0 NOT NULL, "order_id" integer, "reason" text, "state" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "roles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255));
CREATE TABLE "roles_users" ("role_id" integer, "user_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "shipments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "order_id" integer, "shipping_method_id" integer, "tracking" varchar(255), "created_at" datetime, "updated_at" datetime, "number" varchar(255), "cost" decimal(8,2), "shipped_at" datetime, "address_id" integer, "state" varchar(255));
CREATE TABLE "shipping_categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "shipping_methods" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "zone_id" integer, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "shipping_rates" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "shipping_category_id" integer, "shipping_method_id" integer);
CREATE TABLE "state_events" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "stateful_id" integer, "user_id" integer, "name" varchar(255), "created_at" datetime, "updated_at" datetime, "previous_state" varchar(255), "stateful_type" varchar(255));
CREATE TABLE "states" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "abbr" varchar(255), "country_id" integer);
CREATE TABLE "tax_categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "description" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "tax_rates" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "zone_id" integer, "amount" decimal(8,4), "created_at" datetime, "updated_at" datetime, "tax_category_id" integer);
CREATE TABLE "taxonomies" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "taxons" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "taxonomy_id" integer NOT NULL, "parent_id" integer, "position" integer DEFAULT 0, "name" varchar(255) NOT NULL, "created_at" datetime, "updated_at" datetime, "permalink" varchar(255), "lft" integer, "rgt" integer);
CREATE TABLE "trackers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "environment" varchar(255), "analytics_id" varchar(255), "active" boolean DEFAULT 't', "created_at" datetime, "updated_at" datetime);
CREATE TABLE "transactions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "amount" decimal DEFAULT 0.0 NOT NULL, "txn_type" integer, "response_code" varchar(255), "avs_response" text, "cvv_response" text, "created_at" datetime, "updated_at" datetime, "original_creditcard_txn_id" integer, "payment_id" integer, "type" varchar(255));
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "crypted_password" varchar(128), "salt" varchar(128), "remember_token" varchar(255), "remember_token_expires_at" varchar(255), "created_at" datetime, "updated_at" datetime, "persistence_token" varchar(255), "single_access_token" varchar(255), "perishable_token" varchar(255), "login_count" integer DEFAULT 0 NOT NULL, "failed_login_count" integer DEFAULT 0 NOT NULL, "last_request_at" datetime, "current_login_at" datetime, "last_login_at" datetime, "current_login_ip" varchar(255), "last_login_ip" varchar(255), "login" varchar(255), "ship_address_id" integer, "bill_address_id" integer, "openid_identifier" varchar(255), "api_key" varchar(40));
CREATE TABLE "variants" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "product_id" integer, "sku" varchar(255) DEFAULT '' NOT NULL, "price" decimal(8,2) NOT NULL, "weight" decimal(8,2), "height" decimal(8,2), "width" decimal(8,2), "depth" decimal(8,2), "deleted_at" datetime, "is_master" boolean DEFAULT 'f', "count_on_hand" integer DEFAULT 0 NOT NULL, "cost_price" decimal(8,2) DEFAULT NULL);
CREATE TABLE "zone_members" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "zone_id" integer, "zoneable_id" integer, "zoneable_type" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "zones" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "description" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_adjustments_on_order_id" ON "adjustments" ("order_id");
CREATE INDEX "index_assets_on_viewable_id" ON "assets" ("viewable_id");
CREATE INDEX "index_assets_on_viewable_type_and_type" ON "assets" ("viewable_type", "type");
CREATE INDEX "index_configurations_on_name_and_type" ON "configurations" ("name", "type");
CREATE INDEX "index_inventory_units_on_order_id" ON "inventory_units" ("order_id");
CREATE INDEX "index_inventory_units_on_shipment_id" ON "inventory_units" ("shipment_id");
CREATE INDEX "index_inventory_units_on_variant_id" ON "inventory_units" ("variant_id");
CREATE INDEX "index_line_items_on_order_id" ON "line_items" ("order_id");
CREATE INDEX "index_line_items_on_variant_id" ON "line_items" ("variant_id");
CREATE INDEX "index_option_values_variants_on_variant_id" ON "option_values_variants" ("variant_id");
CREATE INDEX "index_option_values_variants_on_variant_id_and_option_value_id" ON "option_values_variants" ("variant_id", "option_value_id");
CREATE INDEX "index_orders_on_number" ON "orders" ("number");
CREATE UNIQUE INDEX "index_preferences_on_owner_and_attribute_and_preference" ON "preferences" ("owner_id", "owner_type", "attribute", "group_id", "group_type");
CREATE INDEX "index_product_groups_on_name" ON "product_groups" ("name");
CREATE INDEX "index_product_groups_on_permalink" ON "product_groups" ("permalink");
CREATE INDEX "index_product_properties_on_product_id" ON "product_properties" ("product_id");
CREATE INDEX "index_product_scopes_on_name" ON "product_scopes" ("name");
CREATE INDEX "index_product_scopes_on_product_group_id" ON "product_scopes" ("product_group_id");
CREATE INDEX "index_products_on_available_on" ON "products" ("available_on");
CREATE INDEX "index_products_on_deleted_at" ON "products" ("deleted_at");
CREATE INDEX "index_products_on_name" ON "products" ("name");
CREATE INDEX "index_products_on_permalink" ON "products" ("permalink");
CREATE INDEX "index_products_taxons_on_product_id" ON "products_taxons" ("product_id");
CREATE INDEX "index_products_taxons_on_taxon_id" ON "products_taxons" ("taxon_id");
CREATE INDEX "index_roles_users_on_role_id" ON "roles_users" ("role_id");
CREATE INDEX "index_roles_users_on_user_id" ON "roles_users" ("user_id");
CREATE INDEX "index_taxons_on_parent_id" ON "taxons" ("parent_id");
CREATE INDEX "index_taxons_on_permalink" ON "taxons" ("permalink");
CREATE INDEX "index_taxons_on_taxonomy_id" ON "taxons" ("taxonomy_id");
CREATE INDEX "index_users_on_openid_identifier" ON "users" ("openid_identifier");
CREATE INDEX "index_variants_on_product_id" ON "variants" ("product_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090823005402');

INSERT INTO schema_migrations (version) VALUES ('20090904192342');

INSERT INTO schema_migrations (version) VALUES ('20090923100315');

INSERT INTO schema_migrations (version) VALUES ('20091007134354');

INSERT INTO schema_migrations (version) VALUES ('20091012120519');

INSERT INTO schema_migrations (version) VALUES ('20091015110842');

INSERT INTO schema_migrations (version) VALUES ('20091015153048');

INSERT INTO schema_migrations (version) VALUES ('20091016174634');

INSERT INTO schema_migrations (version) VALUES ('20091017175558');

INSERT INTO schema_migrations (version) VALUES ('20091021133257');

INSERT INTO schema_migrations (version) VALUES ('20091104151730');

INSERT INTO schema_migrations (version) VALUES ('20091126190904');

INSERT INTO schema_migrations (version) VALUES ('20091209153045');

INSERT INTO schema_migrations (version) VALUES ('20091209202200');

INSERT INTO schema_migrations (version) VALUES ('20091211203813');

INSERT INTO schema_migrations (version) VALUES ('20091212161118');

INSERT INTO schema_migrations (version) VALUES ('20091213222815');

INSERT INTO schema_migrations (version) VALUES ('20091214183826');

INSERT INTO schema_migrations (version) VALUES ('20100105090147');

INSERT INTO schema_migrations (version) VALUES ('20100105132138');

INSERT INTO schema_migrations (version) VALUES ('20100111205525');

INSERT INTO schema_migrations (version) VALUES ('20100112151511');

INSERT INTO schema_migrations (version) VALUES ('20100113090919');

INSERT INTO schema_migrations (version) VALUES ('20100113203104');

INSERT INTO schema_migrations (version) VALUES ('20100121160010');

INSERT INTO schema_migrations (version) VALUES ('20100121183934');

INSERT INTO schema_migrations (version) VALUES ('20100125145351');

INSERT INTO schema_migrations (version) VALUES ('20100126103714');

INSERT INTO schema_migrations (version) VALUES ('20100209025806');

INSERT INTO schema_migrations (version) VALUES ('20100209144531');

INSERT INTO schema_migrations (version) VALUES ('20100213103131');

INSERT INTO schema_migrations (version) VALUES ('20100214212536');

INSERT INTO schema_migrations (version) VALUES ('20100223170312');

INSERT INTO schema_migrations (version) VALUES ('20100223183812');

INSERT INTO schema_migrations (version) VALUES ('20100224153127');

INSERT INTO schema_migrations (version) VALUES ('20100301163454');

INSERT INTO schema_migrations (version) VALUES ('20100306153445');

INSERT INTO schema_migrations (version) VALUES ('20091008091614');

INSERT INTO schema_migrations (version) VALUES ('20100107141738');