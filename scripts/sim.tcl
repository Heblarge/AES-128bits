
create_project -quiet vivado_project ./vivado_project -part xc7z020clg484-1


if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
add_files -norecurse -fileset sources_1 {
  ./src/KeyExpansion.v \
  ./src/invmixColumns_32bit.v \
  ./src/InverseSubBytes.v \
  ./src/InverseShiftRows.v \
  ./src/InverseMixColumns.v \
  ./src/EnRound.v \
  ./src/Encrypt.v \
  ./src/DeRound.v \
  ./src/Decrypt.v \
  ./src/AddRoundKey.v \
  ./src/KeyExpansion_D.v \
  ./src/MixColumns.v \
  ./src/mixColumns_32bit.v \
  ./src/Reg.v \
  ./src/ShiftRows.v \
  ./src/SubBytes.v \
  ./src/top.v \
}
update_compile_order -fileset sources_1


if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
add_files -fileset sim_1 -norecurse {
    ./sim/testbench.v \
    ./sim/key.txt \
    ./sim/plain_text.txt \
    ./sim/cipher_text.txt \
}
update_compile_order -fileset sim_1


set_property -name {xsim.simulate.runtime} -value {15000ns} -objects [get_filesets sim_1]


launch_simulation
close_sim
exit