
## SimInf, a framework for stochastic disease spread simulations
## Copyright (C) 2015 - 2019  Stefan Widgren
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Raise an error if the error message doesn't match.
check_error <- function(current, target, exact = TRUE) {
    if (isTRUE(exact)) {
        stopifnot(identical(current[[1]]$message, target))
    } else {
        stopifnot(length(grep(target, current[[1]]$message)) > 0)
    }

    ## Check that the error message ends with '.'
    stopifnot(length(grep("[.]$", current[[1]]$message)) > 0)

    invisible(NULL)
}