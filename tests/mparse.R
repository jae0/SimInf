## SimInf, a framework for stochastic disease spread simulations
## Copyright (C) 2015 - 2019  Stefan Engblom
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

library("SimInf")

## For debugging
sessionInfo()

## Check that invalid arguments to mparse raises error
res <- tools::assertError(
                  mparse(compartments = c("D","W"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("'transitions' must be specified in a character vector.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = 5,
                         compartments = c("D","W"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("'transitions' must be specified in a character vector.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("'compartments' must be specified in a character vector.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = 5,
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("'compartments' must be specified in a character vector.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         gdata = letters,
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("'gdata' must either be a 'data.frame' or a 'numeric' vector.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D", "W", "D"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("'compartments' must be specified in a character vector.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6, c1 = 2),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("'gdata' must have non-duplicated parameter names.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W"),
                         compartments = c("D","W"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("Invalid transition: 'W->c4[*]W'",
                      res[[1]]$message)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("A->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("Unknown compartment: 'A'[.]",
                      res[[1]]$message)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->B"),
                         compartments = c("D","W"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = 10, W = 10), tspan = 1:5))
stopifnot(length(grep("Unknown compartment: 'B'[.]",
                      res[[1]]$message)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = matrix(c(10, 10), nrow = 1, ncol = 2,
                                     dimnames = list(NULL, c("A", "W"))),
                         tspan = 1:5))
stopifnot(length(grep("Missing columns in u0",
                      res[[1]]$message)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         ldata = 1:5,
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = rep(10, 5), W = 10), tspan = 1:5))
stopifnot(length(grep("'ldata' must either be a 'data.frame' or a 'matrix'.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         ldata = matrix(rep(0, 10), nrow = 2, ncol = 5,
                                        dimnames = list(c("c1", "c1"))),
                         gdata = c(c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = rep(10, 5), W = 10), tspan = 1:5))
stopifnot(length(grep("'ldata' must have non-duplicated parameter names.",
                      res[[1]]$message, fixed = TRUE)) > 0)

res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         ldata = matrix(1:5,, nrow = 1, dimnames = list("c4", NULL)),
                         gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
                         u0 = data.frame(D = rep(10, 5), W = 10), tspan = 1:5))
stopifnot(length(grep("'u0', 'gdata', 'ldata' and 'v0' have names in common.",
                      res[[1]]$message, fixed = TRUE)) > 0)

## Check mparse
m <- mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                            "D+W->c3*D*W->W+W","W->c4*W->@"),
            compartments = c("D","W"),
            gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005, c4 = 0.6),
            u0 = data.frame(D = 10, W = 10), tspan = 1:5)

G <- new("dgCMatrix",
         i = c(1L, 2L, 1L, 2L, 1L, 2L, 3L, 2L, 3L),
         p = c(0L, 2L, 4L, 7L, 9L),
         Dim = c(4L, 4L),
         Dimnames = list(c("@ -> D", "@ -> D",
                           "D -> W", "W -> @"),
                         c("1", "2", "3", "4")),
         x = c(1, 1, 1, 1, 1, 1, 1, 1, 1),
         factors = list())
stopifnot(identical(m@G, G))

S <- new("dgCMatrix",
         i = c(0L, 0L, 0L, 1L, 1L),
         p = c(0L, 1L, 2L, 4L, 5L),
         Dim = c(2L, 4L),
         Dimnames = list(c("D", "W"),
                         c("1", "2", "3", "4")),
         x = c(1, 1, -1, 1, -1),
         factors = list())
stopifnot(identical(m@S, S))

C_code <- c(
    "",
    "#include <R_ext/Rdynload.h>",
    "#include \"SimInf.h\"",
    "",
    "double trFun1(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[0];",
    "}",
    "",
    "double trFun2(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[1]*u[0];",
    "}",
    "",
    "double trFun3(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[2]*u[0]*u[1];",
    "}",
    "",
    "double trFun4(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[3]*u[1];",
    "}",
    "",
    "int ptsFun(",
    "    double *v_new,",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    int node,",
    "    double t)",
    "{",
    "    return 0;",
    "}",
    "",
    "SEXP SimInf_model_run(SEXP model, SEXP threads, SEXP solver)",
    "{",
    "    TRFun tr_fun[] = {&trFun1, &trFun2, &trFun3, &trFun4};",
    "    DL_FUNC SimInf_run = R_GetCCallable(\"SimInf\", \"SimInf_run\");",
    "    return SimInf_run(model, threads, solver, tr_fun, &ptsFun);",
    "}",
    "")
stopifnot(identical(m@C_code[-1], C_code)) ## Skip first line that contains time

## Check mparse with both gdata and ldata
m <- mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                            "D+W->c3*D*W->W+W","W->c4*W->@"),
            compartments = c("D","W"),
            ldata = matrix(rep(0.6, 5), nrow = 1, dimnames = list("c4", NULL)),
            gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005),
            u0 = data.frame(D = rep(10, 5), W = 10), tspan = 1:5)

C_code <- c(
    "",
    "#include <R_ext/Rdynload.h>",
    "#include \"SimInf.h\"",
    "",
    "double trFun1(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[0];",
    "}",
    "",
    "double trFun2(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[1]*u[0];",
    "}",
    "",
    "double trFun3(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[2]*u[0]*u[1];",
    "}",
    "",
    "double trFun4(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return ldata[0]*u[1];",
    "}",
    "",
    "int ptsFun(",
    "    double *v_new,",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    int node,",
    "    double t)",
    "{",
    "    return 0;",
    "}",
    "",
    "SEXP SimInf_model_run(SEXP model, SEXP threads, SEXP solver)",
    "{",
    "    TRFun tr_fun[] = {&trFun1, &trFun2, &trFun3, &trFun4};",
    "    DL_FUNC SimInf_run = R_GetCCallable(\"SimInf\", \"SimInf_run\");",
    "    return SimInf_run(model, threads, solver, tr_fun, &ptsFun);",
    "}",
    "")
stopifnot(identical(m@C_code[-1], C_code)) ## Skip first line that contains time

stopifnot(identical(SimInf:::tokens("beta*S*I/(S+I+R)"),
                    c("beta", "*", "S", "*", "I", "/", "(", "S", "+",
                      "I", "+", "R", ")")))

stopifnot(
    identical(SimInf:::rewrite_propensity("beta*S*I/(S+I+R)", c("S", "I", "R"),
                                          NULL, "beta", NULL),
              structure(list(propensity = "gdata[0]*u[0]*u[1]/(u[0]+u[1]+u[2])",
                             depends = c(1, 1, 1)),
                        .Names = c("propensity", "depends"))))

## Check init function
model <- mparse(transitions = c("S -> b*S*I/(S+I+R) -> I",
                                "I -> g*I -> R"),
                compartments = c("S", "I", "R"),
                gdata = c(b = 0.16, g = 0.077),
                u0 = data.frame(S = 100, I = 1, R = 0),
                tspan = 1:10)
C_code <- c(
    "",
    "#include <R_ext/Rdynload.h>",
    "#include \"SimInf.h\"",
    "",
    "double trFun1(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[0]*u[0]*u[1]/(u[0]+u[1]+u[2]);",
    "}",
    "",
    "double trFun2(",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    double t)",
    "{",
    "    return gdata[1]*u[1];",
    "}",
    "",
    "int ptsFun(",
    "    double *v_new,",
    "    const int *u,",
    "    const double *v,",
    "    const double *ldata,",
    "    const double *gdata,",
    "    int node,",
    "    double t)",
    "{",
    "    return 0;",
    "}",
    "",
    "SEXP SimInf_model_run(SEXP model, SEXP threads, SEXP solver)",
    "{",
    "    TRFun tr_fun[] = {&trFun1, &trFun2};",
    "    DL_FUNC SimInf_run = R_GetCCallable(\"SimInf\", \"SimInf_run\");",
    "    return SimInf_run(model, threads, solver, tr_fun, &ptsFun);",
    "}",
    "")
stopifnot(identical(model@C_code[-1], C_code)) ## Skip first line that contains time

u0 <- structure(c(100L, 1L, 0L),
                .Dim = c(3L, 1L),
                .Dimnames = list(c("S", "I", "R"), NULL))
stopifnot(identical(model@u0, u0))

## Check mparse with ldata and gdata as data.frames
m1 <- mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                             "D+W->c3*D*W->W+W","W->c4*W->@"),
             compartments = c("D","W"),
             ldata = matrix(c(0.2, 0.3, 0.4, 0.5, 0.6), nrow = 1,
                            dimnames = list("c4", NULL)),
             gdata = c(c1 = 0.5, c2 = 1, c3 = 0.005),
             u0 = data.frame(D = rep(10, 5), W = 10), tspan = 1:5)

m2 <- mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                             "D+W->c3*D*W->W+W","W->c4*W->@"),
             compartments = c("D","W"),
             ldata = data.frame(c4 = c(0.2, 0.3, 0.4, 0.5, 0.6)),
             gdata = data.frame(c1 = 0.5, c2 = 1, c3 = 0.005),
             u0 = data.frame(D = rep(10, 5), W = 10), tspan = 1:5)

stopifnot(identical(m1, m2))

## Check that mparse fails with gdata as a 2-row data.frame
res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         ldata = matrix(rep(0.6, 5), nrow = 1, dimnames = list("c4", NULL)),
                         gdata = data.frame(c1 = rep(0.5, 2), c2 = 1, c3 = 0.005),
                         u0 = data.frame(D = rep(10, 5), W = 10), tspan = 1:5))
stopifnot(length(grep("When 'gdata' is a data.frame, it must have one row",
                      res[[1]]$message)) > 0)

## Check mparse fails with ldata as data.frames and nrow(ldata) !=
## nrow(u0)
res <- tools::assertError(
                  mparse(transitions = c("@->c1->D", "D->c2*D->D+D",
                                         "D+W->c3*D*W->W+W","W->c4*W->@"),
                         compartments = c("D","W"),
                         ldata = data.frame(c4 = c(0.2, 0.3, 0.4, 0.5)),
                         gdata = data.frame(c1 = 0.5, c2 = 1, c3 = 0.005),
                         u0 = data.frame(D = rep(10, 5), W = 10), tspan = 1:5))
stopifnot(length(grep("The number of nodes in 'u0' and 'ldata' must match.",
                      res[[1]]$message, fixed = TRUE)) > 0)

## Check 'S + S -> mu -> @'
m  <- mparse(transitions = "S + S -> mu -> @",
             compartments = c("S", "I"),
             gdata = c(mu = 1),
             u0 = data.frame(S = 100, I = 100),
             tspan = 1:100)

S <- new("dgCMatrix", i = 0L, p = 0:1, Dim = 2:1,
         Dimnames = list(c("S", "I"), "1"),
         x = -2, factors = list())
stopifnot(identical(m@S, S))

G <- new("dgCMatrix", i = integer(0), p = c(0L, 0L),
         Dim = c(1L, 1L), Dimnames = list("2*S -> @", "1"),
         x = numeric(0), factors = list())
stopifnot(identical(m@G, G))

## Check 'S + S -> mu -> S + S'
m  <- mparse(transitions = "S + S -> mu -> S + S",
             compartments = c("S", "I"),
             gdata = c(mu = 1),
             u0 = data.frame(S = 100, I = 100),
             tspan = 1:100)

S <- new("dgCMatrix", i = integer(0), p = c(0L, 0L),
         Dim = 2:1, Dimnames = list(c("S", "I"), "1"),
         x = numeric(0), factors = list())
stopifnot(identical(m@S, S))

G <- new("dgCMatrix", i = integer(0), p = c(0L, 0L),
         Dim = c(1L, 1L), Dimnames = list("@ -> @", "1"),
         x = numeric(0), factors = list())
stopifnot(identical(m@G, G))

## Check '@ -> mu-> S + S'
m  <- mparse(transitions = "@ -> mu-> S + S",
             compartments = c("S", "I"),
             gdata = c(mu = 1),
             u0 = data.frame(S = 100, I = 100),
             tspan = 1:100)

S <- new("dgCMatrix", i = 0L, p = 0:1, Dim = 2:1,
         Dimnames = list(c("S", "I"), "1"),
         x = 2, factors = list())
stopifnot(identical(m@S, S))

G <- new("dgCMatrix", i = integer(0), p = c(0L, 0L),
         Dim = c(1L, 1L), Dimnames = list("@ -> 2*S", "1"),
         x = numeric(0), factors = list())
stopifnot(identical(m@G, G))

## Check parsing replicates of compartments
stopifnot(identical(SimInf:::parse_compartments("S + 2*S", c("S", "I")),
                    c(3L, 0L)))

## Check mparse with a compartment name that contains '.', for
## example, '.S.S' (this is a valid column name in a data.frame).
m  <- mparse(transitions = ".S.S -> 1.2*.S.S -> @",
             compartments = c(".S.S"),
             u0 = data.frame(.S.S = 100),
             tspan = 1:100)
stopifnot(identical(m@C_code[13], "    return 1.2*u[0];"))