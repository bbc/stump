defmodule StumpTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  require Logger

  test "time" do
    assert Stump.time == Stump.Time.MockTime.utc_now()
  end

  test "when log level is valid but the message provided is '', it logs an error" do
    assert capture_log(fn ->Stump.log(:error, "") end) == "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"Event Logger received log level, but no error message was provided\"}\n"
  end

  test "when log level is valid but the message provided is nil, it logs an error" do
    assert capture_log(fn ->Stump.log(:error, nil) end) == "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"Event Logger received log level, but no error message was provided\"}\n"
  end

  test "when log level is :info and a message is provided it, it logs as JSON" do
    assert capture_log(fn ->Stump.log(:info, "Here is some info") end) == "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"info\",\"message\":\"Here is some info\"}\n"
  end

  test "when log level is :warn and a message is provided it, it logs as JSON" do
    assert capture_log(fn ->Stump.log(:warn, "This is a warning") end) == "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"warn\",\"message\":\"This is a warning\"}\n"
  end

  test "when log level is :error and a message is provided it, it logs as JSON" do
    assert capture_log(fn ->Stump.log(:error, "There was an error") end) == "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"There was an error\"}\n"
  end
end
