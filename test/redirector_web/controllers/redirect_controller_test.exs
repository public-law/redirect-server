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

  #
  # Searches
  #
  test "An oregonlaws search", %{conn: conn} do
    assert_redirect(conn, "/page?page=24&search=filing+fee", "https://oregon.public.law/search?term=filing+fee&page=24")
  end


  test "An oregonlaws search without page", %{conn: conn} do
    assert_redirect(conn, "/page?search=probate", "https://oregon.public.law/search?term=probate")
  end


  test "An oregonlaws search with object filter", %{conn: conn} do
    assert_redirect(conn, "/page?object_filter=36&page=15&search=access", "https://oregon.public.law/search?term=access&page=15")
  end


  #
  # General
  #

  test "Catch-all for GET", %{conn: conn} do
    assert_redirect(conn, "/statutes/ors_316.003", "https://oregon.public.law/statutes/ors_316.003")
  end


  test "Catch-all works with weird stuff", %{conn: conn} do
    assert_redirect(conn, "/1/2/3/4/5.txt", "https://oregon.public.law/1/2/3/4/5.txt")
  end


  test "Catch-all works with just one word", %{conn: conn} do
    assert_redirect(conn, "/robb", "https://oregon.public.law/robb")
  end


  test "Catch-all works with older volume path", %{conn: conn} do
    assert_redirect(conn, "/ors/2011/volume/14", "https://oregon.public.law/ors/2011/volume/14")
  end


  test "Sign-in goes to the new site", %{conn: conn} do
    assert_redirect(conn, "/users/sign_in", "https://oregon.public.law/users/sign_in")
  end


  test "ads.txt goes to new site", %{conn: conn} do
    assert_redirect(conn, "/ads.txt", "https://oregon.public.law/ads.txt")
  end


  test "Sitemap goes to new site", %{conn: conn} do
    assert_redirect(conn, "/sitemap.xml.gz", "https://oregon.public.law/sitemaps/sitemap.xml.gz")
  end


  #
  # Blog
  #

  test "Blog page goes to the correct site", %{conn: conn} do
    assert_redirect(conn, "/blog/2009/08/how-does-oregonlawsorg-work", "https://blog.public.law/2009/08/how-does-oregonlawsorg-work")
  end

  test "Blog feed goes to new blog location", %{conn: conn} do
    assert_redirect(conn, "/blog/feed/", "https://blog.public.law/feed/")
  end

  test "Blog rss", %{conn: conn} do
    assert_redirect(conn, "/rss", "https://blog.public.law/rss")
  end

  test "Robb's blog feed goes to new blog location", %{conn: conn} do
    assert_redirect(conn, "/robb/feed/", "https://dogweather.dev/feed/")
  end

  #
  # Other
  #

  test "A simple page redirect", %{conn: conn} do
    assert_redirect(conn, "/robots.txt", "https://oregon.public.law/robots.txt")
  end

  #
  # Bad requests
  #
  test "POST requests to root are 400", %{conn: conn} do
    conn = post(conn, "/")
    assert conn.status == 400
  end

  test "POST requests to a path are 400", %{conn: conn} do
    conn = post(conn, "/1")
    assert conn.status == 400
  end

  #
  # Glossary Redirects
  #

  test "Glossary redirects", %{conn: conn} do
    assert_redirect(conn, "/glossary/definition/alternate_juror", "https://www.public.law/dictionary/entries/alternate-juror")
  end

  test "Glossary root", %{conn: conn} do
    assert_redirect(conn, "/glossary", "https://www.public.law/dictionary")
  end

  #
  # ORS Redirects
  #

  test "ORS home page goes to the right place", %{conn: conn} do
    assert_redirect(conn, "http://www.oregonlaws.org/", "https://oregon.public.law")
  end

  test "ORS statutes goes to the right place", %{conn: conn} do
    assert_redirect(conn, "/oregon_revised_statutes", "https://oregon.public.law/statutes")
  end

  test "ORS Volume request", %{conn: conn} do
    assert_redirect(conn, "/ors/volume/6", "https://oregon.public.law/statutes/ors_volume_6")
  end

  test "ORS Chapter request", %{conn: conn} do
    assert_redirect(conn, "/ors/chapter/6", "https://oregon.public.law/statutes/ors_chapter_6")
  end

  test "Alternate ORS Chapter request", %{conn: conn} do
    assert_redirect(conn, "/ors_chapters/352", "https://oregon.public.law/statutes/ors_chapter_352")
  end

  test "ORS Section request", %{conn: conn} do
    assert_redirect(conn, "/ors/123.456", "https://oregon.public.law/statutes/ors_123.456")
  end

  test "ORS Section with year", %{conn: conn} do
    assert_redirect(conn, "/ors/2007/497.040", "https://oregon.public.law/statutes/ors_497.040")
  end

  test "ORS Chapter with year", %{conn: conn} do
    assert_redirect(conn, "/ors/2013/chapter/777", "https://oregon.public.law/statutes/ors_chapter_777")
  end

  #
  # Weblaws.org Redirects
  #

  test "http://www.weblaws.org/states/new_york", %{conn: conn} do
    assert_redirect(conn, "http://www.weblaws.org/states/new_york", "https://newyork.public.law")
  end

  test "redirect_root/2 sends to www.public.law", %{conn: conn} do
    assert_redirect(conn, "http://www.weblaws.org/", "https://www.public.law")
  end

  test "basic state redirect", %{conn: conn} do
    assert_redirect(conn, "/texas/statutes/tex._election_code", "https://texas.public.law/statutes/tex._election_code")
  end

  test "leaf node New York redirect", %{conn: conn} do
    assert_redirect(conn, "/new_york/laws/n.y._multiple_dwelling_law_section_2", "https://newyork.public.law/laws/n.y._multiple_dwelling_law_section_2")
  end

  test "leaf node California redirect", %{conn: conn} do
    assert_redirect(conn, "/california/codes/ca_sts_and_high_code_div_1_chap_1.5", "https://california.public.law/codes/ca_sts_and_high_code_div_1_chap_1.5")
  end

  test "very old-style california redirect", %{conn: conn} do
    assert_redirect(conn, "/states/california/statutes/ca_penal_section_459", "https://california.public.law/codes/ca_penal_code_section_459")
  end

  test "http://www.weblaws.org/states/california/statutes", %{conn: conn} do
    assert_redirect(conn, "/states/california/statutes", "https://california.public.law/codes")
  end
end
