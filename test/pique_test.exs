defmodule PiqueTest do
  use ExUnit.Case
  import Pique

  describe "validate_ssl_options/1" do
    test "does nothing if auth is set to false" do
      assert validate_ssl_options([]) == nil
    end

    test "exits if auth is set to true, protocol is not defined" do
      Application.put_env(:pique, :auth, true)
      assert catch_exit(validate_ssl_options([]))
      Application.delete_env(:pique, :auth)
    end

    test "exits if auth is set to true, protocol is tcp" do
      Application.put_env(:pique, :auth, true)
      assert catch_exit(validate_ssl_options([protocol: :tcp]))
      Application.delete_env(:pique, :auth)
    end

    test "exits if auth is set to true, protocol is ssl, no sessionoptions" do
      Application.put_env(:pique, :auth, true)
      assert catch_exit(validate_ssl_options([protocol: :ssl]))
      Application.delete_env(:pique, :auth)
    end

    test "exits if auth is set to true protocol is ssl, sessionoptions are set, certfile is missing" do
      Application.put_env(:pique, :auth, true)
      assert catch_exit(validate_ssl_options([protocol: :ssl, sessionoptions: []]))
      Application.delete_env(:pique, :auth)
    end

    test "exits if auth is set to true protocol is ssl, sessionoptions are set, keyfile is missing" do
      Application.put_env(:pique, :auth, true)
      assert catch_exit(validate_ssl_options([protocol: :ssl, sessionoptions: [certfile: "foo"]]))
      Application.delete_env(:pique, :auth)
    end

    test "passes if auth is set to true protocol is ssl, sessionoptions are set, certfile is set, keyfile is set" do
      Application.put_env(:pique, :auth, true)
      assert validate_ssl_options([protocol: :ssl, sessionoptions: [certfile: "foo", keyfile: "bar"]]) == nil
      Application.delete_env(:pique, :auth)
    end
  end
end
