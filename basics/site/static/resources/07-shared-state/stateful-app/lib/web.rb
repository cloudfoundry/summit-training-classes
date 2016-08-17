require "sinatra/base"
require "redis"
require "redis-namespace"

require "json"
require "ostruct"
require "securerandom"

VCAP_APPLICATION = JSON.parse(ENV.fetch("VCAP_APPLICATION", JSON.dump({
  space_id: SecureRandom.uuid
})))

CF_APP = OpenStruct.new(VCAP_APPLICATION)

VCAP_SERVICES = JSON.parse(ENV.fetch("VCAP_SERVICES", JSON.dump({
  rediscloud: [ {
    credentials: {
      hostname: "localhost",
      password: nil,
      port: 6379,
    }
  } ],
  redis: [ {
    credentials: {
      hostname: "localhost",
      password: nil,
      port: 6379,
    }
  } ],
})))

if VCAP_SERVICES.has_key?("user-provided")
  REDIS_SERVICES = VCAP_SERVICES.fetch("user-provided").select do |service|
    service.fetch("name").index("redis")
  end
else
  REDIS_SERVICES = VCAP_SERVICES.select { |key, _| key.index("redis") }.values.first
end

REDIS_CREDENTIALS = OpenStruct.new(REDIS_SERVICES.first.fetch("credentials"))

REDIS = Redis::Namespace.new(CF_APP.space_id, redis: Redis.new(
  host: REDIS_CREDENTIALS.hostname,
  password: REDIS_CREDENTIALS.password,
  port: REDIS_CREDENTIALS.port
))

class Web < Sinatra::Base
  helpers do
    def addr
      @addr ||= ENV.fetch("CF_INSTANCE_ADDR") {
        [
          env.fetch("SERVER_NAME", "127.0.0.1"),
          env.fetch("SERVER_PORT", "*"),
        ].join(":")
      }
    end

    def instance
      @instance ||= ENV.fetch("CF_INSTANCE_INDEX", 0)
    end
  end

  get "/" do
    @total_instance_responses = REDIS.incr("total_instance_#{addr}_responses")
    @total_app_responses = REDIS.incr("total_app_responses")
    @app_supporters = REDIS.zrevrange("app_supporters", 0, -1)
    erb :index
  end

  post "/app_supporters" do
    REDIS.zadd("app_supporters", Time.now.utc.to_i, params[:name])
    redirect to("/")
  end

  get "/env" do
    content_type "application/json"
    JSON.pretty_generate(ENV.to_h)
  end
end
