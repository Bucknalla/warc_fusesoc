#!/usr/bin/python
from fusesoc.capi2.generator import Generator
import subprocess
from switch_wrapper import generate

class AxisSwitchGenerator(Generator):
    def run(self):
        ports    = self.config.get('ports', 8)
        name     = self.config.get('name', "axis_arb_mux_wrap_{0}".format(ports))
        output   = self.config.get('output', name+'.v')

        generate(ports, name, output)

        self.add_files([{output : {'file_type' : 'verilogSource',}}])

g = AxisSwitchGenerator()
g.run()
g.write()