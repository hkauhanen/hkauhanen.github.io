iterate_with_checkpointing <- function(FUN,
                                       pars = list(),
                                       initial_value = list(),
                                       outcolumns,
                                       pass = "iterator_only",
                                       max_iteration,
                                       start_iteration = 1,
                                       checkpoint_file = "./checkpoint.Rdata") {
  # check whether checkpoint file exists; if so, load environment
  if (file.exists(checkpoint_file)) {
    load(checkpoint_file)
  } else {
    # if checkpoint file does not exist, we initialize a data frame for the
    # results and set checkpoint iterator to the start value. If user has
    # provided an initial value, this is taken into account
    if (length(initial_value) == 0) {
      checkpointing_iter <- start_iteration
      results <- data.frame(iteration=1:max_iteration, stringsAsFactors=FALSE)
      for (oc in outcolumns) {
        results[[oc]] <- NA
      }
    } else {
      checkpointing_iter <- start_iteration + 1
      results <- data.frame(iteration=1:max_iteration, stringsAsFactors=FALSE)
      for (oc in outcolumns) {
        results[[oc]] <- NA
        results[[oc]][1] <- initial_value[[oc]]
      }
    }
  }

  # check what sort of pass behaviour was requested
  possible_behaviours <- c("iterator_only", "previous_iteration", "full_results")
  to_pass <- charmatch(pass, c("iterator_only", "previous_iteration", "full_results")) # this is 1, 2 or 3 depending on selection

  # iterate
  if (is.na(to_pass)) {
    stop("Invalid value of 'pass' argument. Possible values are 'iterator_only', 'previous_iteration' and 'full_results', or any of their partial matches.")
  } else if (to_pass == 1) {
    while (checkpointing_iter <= max_iteration) {
      # add desired stuff to pass to FUN
      pars$iteration = checkpointing_iter

      # call FUN
      results[checkpointing_iter, ] <- do.call(FUN, pars)

      # increase iteration, save current state
      checkpointing_iter <- checkpointing_iter + 1
      save(results, checkpointing_iter, file=checkpoint_file)
    }
  } else if (to_pass == 2) {
    while (checkpointing_iter <= max_iteration) {
      # add desired stuff to pass to FUN
      pars$iteration = checkpointing_iter
      pars$previous_iteration = results[checkpointing_iter - 1, ]

      # call FUN
      results[checkpointing_iter, ] <- do.call(FUN, pars)

      # increase iteration, save current state
      checkpointing_iter <- checkpointing_iter + 1
      save(results, checkpointing_iter, file=checkpoint_file)
    }
  } else if (to_pass == 3) {
    while (checkpointing_iter <= max_iteration) {
      # add desired stuff to pass to FUN
      pars$iteration = checkpointing_iter
      pars$previous_iteration = results[checkpointing_iter - 1, ]
      pars$full_results = results

      # call FUN
      results[checkpointing_iter, ] <- do.call(FUN, pars)

      # increase iteration, save current state
      checkpointing_iter <- checkpointing_iter + 1
      save(results, checkpointing_iter, file=checkpoint_file)
    }
  }

  # return
  results
}
