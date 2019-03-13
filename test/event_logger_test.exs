defmodule StumpTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  require Logger

  test "time" do
    assert Stump.time == Stump.Time.MockTime.utc_now()
  end

  test "when log level is valid but the message provided is '', it logs an error" do
    assert capture_log(fn ->Stump.log(:error, "") end) == "{\"message\":\"Event Logger received log level, but no error message was provided\",\"level\":\"error\",\"datetime\":\"2019-03-01T00:00:00Z\"}\n"
  end

  test "when log level is valid but the message provided is nil, it logs an error" do
    assert capture_log(fn ->Stump.log(:error, nil) end) == "{\"message\":\"Event Logger received log level, but no error message was provided\",\"level\":\"error\",\"datetime\":\"2019-03-01T00:00:00Z\"}\n"
  end

  test "when log level is :info and a message is provided it, it logs as JSON" do
    assert capture_log(fn ->Stump.log(:info, "Here is some info") end) == "{\"message\":\"Here is some info\",\"level\":\"info\",\"datetime\":\"2019-03-01T00:00:00Z\"}\n"
  end

  test "when log level is :warn and a message is provided it, it logs as JSON" do
    assert capture_log(fn ->Stump.log(:warn, "This is a warning") end) == "{\"message\":\"This is a warning\",\"level\":\"warn\",\"datetime\":\"2019-03-01T00:00:00Z\"}\n"
  end

  test "when log level is :error and a message is provided it, it logs as JSON" do
    assert capture_log(fn ->Stump.log(:error, "There was an error") end) == "{\"message\":\"There was an error\",\"level\":\"error\",\"datetime\":\"2019-03-01T00:00:00Z\"}\n"
  end
end
