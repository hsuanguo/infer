(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd

let log_lock_time = Stats.add_to_proc_locker_lock_time

let log_unlock_time = Stats.add_to_proc_locker_unlock_time

let record_time_of ~f ~log_f =
  let ExecutionDuration.{result; execution_duration} = ExecutionDuration.timed_evaluate ~f in
  log_f execution_duration ;
  result


let locks_dir = ResultsDir.get_path ProcnamesLocks

let setup () =
  Utils.rmtree locks_dir ;
  Utils.create_dir locks_dir ;
  ()


let lock_of_filename filename = locks_dir ^/ filename

let lock_of_procname pname = lock_of_filename (Procname.to_filename pname)

let unlock pname =
  record_time_of ~log_f:log_unlock_time ~f:(fun () ->
      try Unix.unlink (lock_of_procname pname)
      with Unix.Unix_error (ENOENT, _, _) ->
        Die.die InternalError "Tried to unlock not-locked pname: %a@\n" Procname.pp pname )


let try_taking_lock filename =
  Unix.openfile ~mode:[O_CREAT; O_RDONLY; O_EXCL] filename |> Unix.close


let try_lock pname =
  record_time_of ~log_f:log_lock_time ~f:(fun () ->
      try
        try_taking_lock (lock_of_procname pname) ;
        true
      with Unix.Unix_error ((EEXIST | EACCES), _, _) -> false )


let is_locked ~proc_filename =
  try
    ignore (Unix.lstat (lock_of_filename proc_filename)) ;
    true
  with Unix.Unix_error (ENOENT, _, _) -> false
