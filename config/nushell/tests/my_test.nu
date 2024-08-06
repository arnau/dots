use std assert
use $"($nu.default-config-dir)/my.nu" *

#[test]
def test_string_to_weeknumber [] {
    assert equal ("2023-12-11" | date to-weeknumber) 50
    assert equal (["2023-12-10"] | date to-weeknumber) [49]
}

#[test]
def test_date_to_weeknumber [] {
    assert equal ("2023-12-11" | into datetime | date to-weeknumber) 50
}


#[test]
def test_int_to_weeknumber [] {
    assert equal (1702294891000000000 | date to-weeknumber) 50
    assert equal ([1702294891000000000] | date to-weeknumber) [50]
}
