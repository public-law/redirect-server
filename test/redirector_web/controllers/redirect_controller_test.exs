defmodule RedirectorWeb.RedirectControllerTest do
  @moduledoc """
  Test the redirect function.
  """
  use RedirectorWeb.ConnCase

  # Helper function to assert redirects
  defp assert_redirect(conn, from, to) do
    conn = get(conn, from)
    assert conn.status == 301
    assert get_resp_header(conn, "location") == [to]
  end

  describe "Searches" do
    test "An oregonlaws search", %{conn: conn} do
      assert_redirect(conn, "/page?page=24&search=filing+fee", "https://oregon.public.law/search?term=filing+fee&page=24")
    end

    test "An oregonlaws search without page", %{conn: conn} do
      assert_redirect(conn, "/page?search=probate", "https://oregon.public.law/search?term=probate")
    end

    test "An oregonlaws search with object filter", %{conn: conn} do
      assert_redirect(conn, "/page?object_filter=36&page=15&search=access", "https://oregon.public.law/search?term=access&page=15")
    end
  end

  # Define all the redirect test cases
  @redirects %{
    general: [
      {"Catch-all for GET", "/statutes/ors_316.003", "https://oregon.public.law/statutes/ors_316.003"},
      {"Weird path with numbers", "/1/2/3/4/5.txt", "https://oregon.public.law/1/2/3/4/5.txt"},
      {"Single word path", "/robb", "https://oregon.public.law/robb"},
      {"Older volume path", "/ors/2011/volume/14", "https://oregon.public.law/ors/2011/volume/14"},
      {"Sign-in page", "/users/sign_in", "https://oregon.public.law/users/sign_in"},
      {"Ads.txt file", "/ads.txt", "https://oregon.public.law/ads.txt"},
      {"Sitemap file", "/sitemap.xml.gz", "https://oregon.public.law/sitemaps/sitemap.xml.gz"}
    ],
    blog: [
      {"Blog page", "/blog/2009/08/how-does-oregonlawsorg-work", "https://blog.public.law/2009/08/how-does-oregonlawsorg-work"},
      {"Blog feed", "/blog/feed/", "https://blog.public.law/feed/"},
      {"Blog RSS", "/rss", "https://blog.public.law/rss"},
      {"Robb's blog feed", "/robb/feed/", "https://dogweather.dev/feed/"},
      {"Simple page", "/robots.txt", "https://oregon.public.law/robots.txt"}
    ],
    glossary: [
      {"Definition", "/glossary/definition/alternate_juror", "https://www.public.law/dictionary/entries/alternate-juror"},
      {"Root", "/glossary", "https://www.public.law/dictionary"}
    ],
    ors: [
      {"Home page", "http://www.oregonlaws.org/", "https://oregon.public.law"},
      {"Statutes page", "/oregon_revised_statutes", "https://oregon.public.law/statutes"},
      {"Volume request", "/ors/volume/6", "https://oregon.public.law/statutes/ors_volume_6"},
      {"Chapter request", "/ors/chapter/6", "https://oregon.public.law/statutes/ors_chapter_6"},
      {"Alternate chapter request", "/ors_chapters/352", "https://oregon.public.law/statutes/ors_chapter_352"},
      {"Section request", "/ors/123.456", "https://oregon.public.law/statutes/ors_123.456"},
      {"Section with year", "/ors/2007/497.040", "https://oregon.public.law/statutes/ors_497.040"},
      {"Chapter with year", "/ors/2013/chapter/777", "https://oregon.public.law/statutes/ors_chapter_777"}
    ],
    weblaws: [
      {"New York state page", "http://www.weblaws.org/states/new_york", "https://newyork.public.law"},
      {"Root to www.public.law", "http://www.weblaws.org/", "https://www.public.law"},
      {"Texas election code", "/texas/statutes/tex._election_code", "https://texas.public.law/statutes/tex._election_code"},
      {"New York dwelling law", "/new_york/laws/n.y._multiple_dwelling_law_section_2", "https://newyork.public.law/laws/n.y._multiple_dwelling_law_section_2"},
      {"California highway code", "/california/codes/ca_sts_and_high_code_div_1_chap_1.5", "https://california.public.law/codes/ca_sts_and_high_code_div_1_chap_1.5"},
      {"Old-style California redirect", "/states/california/statutes/ca_penal_section_459", "https://california.public.law/codes/ca_penal_code_section_459"},
      {"California statutes", "/states/california/statutes", "https://california.public.law/codes"}
    ]
  }

  # Create tests for each group of redirects
  describe "General redirects" do
    for {name, from, to} <- @redirects.general do
      @name name
      @from from
      @to to
      test "#{@name}", %{conn: conn} do
        assert_redirect(conn, @from, @to)
      end
    end
  end

  describe "Blog redirects" do
    for {name, from, to} <- @redirects.blog do
      @name name
      @from from
      @to to
      test "#{@name}", %{conn: conn} do
        assert_redirect(conn, @from, @to)
      end
    end
  end

  describe "Bad requests" do
    test "POST requests to root are 400", %{conn: conn} do
      conn = post(conn, "/")
      assert conn.status == 400
    end

    test "POST requests to a path are 400", %{conn: conn} do
      conn = post(conn, "/1")
      assert conn.status == 400
    end
  end

  describe "Glossary redirects" do
    for {name, from, to} <- @redirects.glossary do
      @name name
      @from from
      @to to
      test "#{@name}", %{conn: conn} do
        assert_redirect(conn, @from, @to)
      end
    end
  end

  describe "ORS redirects" do
    for {name, from, to} <- @redirects.ors do
      @name name
      @from from
      @to to
      test "#{@name}", %{conn: conn} do
        assert_redirect(conn, @from, @to)
      end
    end
  end

  describe "Weblaws.org redirects" do
    for {name, from, to} <- @redirects.weblaws do
      @name name
      @from from
      @to to
      test "#{@name}", %{conn: conn} do
        assert_redirect(conn, @from, @to)
      end
    end
  end
end
