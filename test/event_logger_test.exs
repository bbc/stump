defmodule StumpTest do
  defstruct message: "There was an error"

  use ExUnit.Case
  import ExUnit.CaptureLog
  require Logger

  test "time" do
    assert Stump.time() == Stump.Time.MockTime.utc_now()
  end

  describe "supports log levels" do
    test "error" do
      capture_log(fn -> Stump.log(:error, "A log message") end)
    end

    test "warn" do
      capture_log(fn -> Stump.log(:warn, "A log message") end)
    end

    test "info" do
      capture_log(fn -> Stump.log(:info, "A log message") end)
    end

    test "debug" do
      capture_log(fn -> Stump.log(:debug, "A log message") end)
    end

    test "rejects unsupported log level" do
      assert_raise(FunctionClauseError, fn ->
        capture_log(fn -> Stump.log(:emergency, "A log message") end)
      end)
    end
  end

  describe "success" do
    test "when log level is :info and a message is provided it, it logs as JSON" do
      assert capture_log(fn -> Stump.log(:info, "Here is some info") end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"info\",\"message\":\"Here is some info\",\"metadata\":{}}\n"
    end

    test "when log level is :warn and a message is provided it, it logs as JSON" do
      assert capture_log(fn -> Stump.log(:warn, "This is a warning") end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"warn\",\"message\":\"This is a warning\",\"metadata\":{}}\n"
    end

    test "when log level is :error and a message is provided it, it logs as JSON" do
      assert capture_log(fn -> Stump.log(:error, "There was an error") end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"There was an error\",\"metadata\":{}}\n"
    end

    test "when Stump receives a map it encodes it and logs it" do
      assert capture_log(fn -> Stump.log(:error, %{message: "There was an error"}) end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"There was an error\",\"metadata\":{}}\n"
    end

    test "when Stump receives a struct it trasforms it to a map encodes it and logs it" do
      assert capture_log(fn ->
               Stump.log(:error, %StumpTest{message: "This is the message from the struct"})
             end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"This is the message from the struct\",\"metadata\":{}}\n"
    end

    test "when Stump receives nested structs it recursively turns them into maps to avoid Jason errors" do
      assert capture_log(fn ->
               Stump.log(:error, %{
                 message: "This is an error",
                 struct: %StumpTest{message: "I am a struct"}
               })
             end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"This is an error\",\"metadata\":{},\"struct\":{\"message\":\"I am a struct\"}}\n"
    end

    test "When receiving a Map containing a tuple, it converts the tuple into a list" do
      assert capture_log(fn ->
               Stump.log(:error, %{tuple: {:this_is, "a tuple"}})
             end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"metadata\":{},\"tuple\":[\"this_is\",\"a tuple\"]}\n"
    end

    test "When receiving a Map containing a List containing a tuple, it converts the tuple inside the list into a list" do
      assert capture_log(fn ->
               Stump.log(:error, %{list: [1, 2, 3, {:this_is, "a tuple"}]})
             end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"list\":[1,2,3,[\"this_is\",\"a tuple\"]],\"metadata\":{}}\n"
    end

    test "When using Stump.metadata subsequent logs are labeled with said metadata" do
      Stump.metadata(metadata_label: "some_metadata")

      assert capture_log(fn -> Stump.log(:info, "There will be metadata with this!") end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"info\",\"message\":\"There will be metadata with this!\",\"metadata\":{\"metadata_label\":\"some_metadata\"}}\n"
    end

    test "When receiving a tuple containing an Elixir Reference replace it with a placeholder" do
      assert capture_log(fn ->
               Stump.log(:error, %{show_a_ref: make_ref()})
             end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"metadata\":{},\"show_a_ref\":\"#Ref<>\"}\n"
    end

    test "When receiving a tuple containing a Pid replace it with a placeholder" do
      assert capture_log(fn ->
               Stump.log(:error, %{show_a_pid: self()})
             end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"metadata\":{},\"show_a_pid\":\"#Pid<>\"}\n"
    end

    test "When receiving metadata it passes it through to the logger" do
      assert capture_log(fn ->
               Stump.log(
                 :error,
                 %{
                   message: "This is an error"
                 },
                 some_metadata: "yes"
               )
             end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"This is an error\",\"metadata\":{}}\n"
    end
  end

  describe "failure" do
    test "when log level is valid but the message provided is '', it logs an error" do
      assert capture_log(fn -> Stump.log(:error, "") end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"Event Logger received log level, but no error message was provided\",\"metadata\":{}}\n"
    end

    test "when log level is valid but the message provided is nil, it logs an error" do
      assert capture_log(fn -> Stump.log(:error, nil) end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"level\":\"error\",\"message\":\"Event Logger received log level, but no error message was provided\",\"metadata\":{}}\n"
    end

    test "when Stump receives data it cannot encode, it logs the error" do
      assert capture_log(fn -> Stump.log(:error, <<0x80>>) end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"jason_error\":\"Jason returned an error encoding your log message\",\"raw_log\":\"%{datetime: \\\"2019-03-01T00:00:00Z\\\", level: \\\"error\\\", message: <<128>>, metadata: %{}}\"}\n"
    end

    test "when Stump receives a map containing data it cannot encode, it logs the error" do
      assert capture_log(fn -> Stump.log(:error, %{message: <<0x80>>}) end) ==
               "{\"datetime\":\"2019-03-01T00:00:00Z\",\"jason_error\":\"Jason returned an error encoding your log message\",\"raw_log\":\"%{datetime: \\\"2019-03-01T00:00:00Z\\\", level: \\\"error\\\", message: <<128>>, metadata: %{}}\"}\n"
    end
  end
end
