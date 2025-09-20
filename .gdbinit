set debuginfod enabled on
set breakpoint pending on

set tui compact-source on
set tui border-kind acs
set tui border-mode normal
set tui active-border-mode normal
set tui tab-width 4
set tui mouse-events on
tui enable

break __assert_fail
commands
    frame 1
    info locals
end
