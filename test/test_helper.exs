ExUnit.start()

defmodule RedirectorWeb.TestHelpers do
  import Phoenix.ConnTest
  import Plug.Conn
  import ExUnit.Assertions

  @endpoint RedirectorWeb.Endpoint

  # Helper function to assert redirects
  def assert_redirect(conn, from, to) do
    conn = get(conn, from)
    assert conn.status == 301
    assert get_resp_header(conn, "location") == [to]
  end

  # Import this module into your tests
  defmacro define_redirect_tests(description, redirects) do
    quote bind_quoted: [description: description, redirects: redirects] do
      describe description do
        for {name, from, to} <- redirects do
          @name name
          @from from
          @to to
          test "#{@name}", %{conn: conn} do
            assert_redirect(conn, @from, @to)
          end
        end
      end
    end
  end
end
