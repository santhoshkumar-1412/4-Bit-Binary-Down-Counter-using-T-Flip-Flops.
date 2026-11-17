
# 4-Bit Binary Down Counter Using T Flip-Flops | Verilog HDL

<p align="center">
  <b>RTL Design | Digital Electronics | Functional Verification</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Design-Sequential%20Logic-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Simulation-Synopsys%20VCS-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Debugging-Synopsys%20Verdi-purple?style=for-the-badge" />
</p>

## 1. Project Overview

This project presents the RTL design and functional verification of a **4-bit asynchronous binary down counter using T (Toggle) flip-flops** in Verilog Hardware Description Language (HDL).

The counter consists of four cascaded T flip-flops, where each flip-flop toggles its output based on the positive edge of the preceding flip-flop's output.

The design uses an asynchronous active-high reset to initialize all four flip-flop outputs to `0000`.

The project explores sequential circuit design, T flip-flop operation, ripple counter architecture, binary down-counting, and functional verification.

The RTL design is simulated using **Synopsys VCS**, while waveform visualization and debugging are performed using **Synopsys Verdi**.

## 2. Design Specifications

| Parameter | Description |
|---|---|
| Design Name | 4-Bit Binary Down Counter |
| Design Type | Sequential Logic |
| Counter Type | Asynchronous (Ripple) Counter |
| Flip-Flop Type | T Flip-Flop |
| Number of Flip-Flops | 4 |
| Counter Width | 4 Bits |
| Clock Edge | Positive Edge |
| Reset Type | Asynchronous Reset |
| Reset Polarity | Active High |
| Reset Value | 0000 |
| HDL | Verilog |
| RTL Simulator | Synopsys VCS |
| Waveform Viewer | Synopsys Verdi |
| Waveform Format | FSDB |

## 3. Design Architecture

The design consists of four T flip-flops connected in a cascaded configuration.

- The first flip-flop receives the external clock.
- The second flip-flop receives the output of the first flip-flop as its clock.
- The third flip-flop receives the output of the second flip-flop as its clock.
- The fourth flip-flop receives the output of the third flip-flop as its clock.
- All four flip-flops share a common asynchronous active-high reset signal.

Since each T input is connected to logic HIGH (`1'b1`), every flip-flop toggles its output whenever a positive clock edge occurs.

This configuration forms an asynchronous ripple counter.

### 3.1 T Flip-Flop Operation

A T flip-flop changes its output when T = 1 and maintains its previous state when T = 0.

| T Input | Clock Edge | Next State |
|---|---|---|
| 0 | Positive Edge | No Change |
| 1 | Positive Edge | Toggle |

**Characteristic Equation:**

```text
Q_next = T XOR Q
```

For individual flip-flop stages:

```text
Q0_next = T0 XOR Q0
Q1_next = T1 XOR Q1
Q2_next = T2 XOR Q2
Q3_next = T3 XOR Q3
```

In this implementation:

```text
T0 = T1 = T2 = T3 = 1
```

Therefore:

```text
Q0_next = NOT Q0
Q1_next = NOT Q1
Q2_next = NOT Q2
Q3_next = NOT Q3
```

### 3.2 Counter Architecture

The four T flip-flops are connected as follows:

| Flip-Flop | Clock Input | T Input |
|---|---|---|
| TFF0 | External Clock | 1 |
| TFF1 | Q0 | 1 |
| TFF2 | Q1 | 1 |
| TFF3 | Q2 | 1 |

The output of each flip-flop acts as the clock for the next flip-flop.

### 3.3 Intended Down-Counting Sequence

The intended 4-bit binary down-counting sequence is:

| Count | Q[3:0] | Decimal Value |
|---:|:---:|---:|
| Reset | 0000 | 0 |
| 1 | 1111 | 15 |
| 2 | 1110 | 14 |
| 3 | 1101 | 13 |
| 4 | 1100 | 12 |
| 5 | 1011 | 11 |
| 6 | 1010 | 10 |
| 7 | 1001 | 9 |
| 8 | 1000 | 8 |
| 9 | 0111 | 7 |
| 10 | 0110 | 6 |
| 11 | 0101 | 5 |
| 12 | 0100 | 4 |
| 13 | 0011 | 3 |
| 14 | 0010 | 2 |
| 15 | 0001 | 1 |
| 16 | 0000 | 0 |

The intended sequence repeats continuously until reset is asserted again.

**Important RTL consideration:** The supplied implementation connects positive-edge-triggered flip-flops through Q outputs. A conventional ripple down counter using positive-edge-triggered flip-flops generally requires the complemented output (Q-bar) of each preceding stage to clock the next stage. Alternatively, negative-edge-triggered flip-flops can be used with Q connections. Therefore, the actual counting sequence must be verified against the RTL and simulation waveform.

## 4. RTL Implementation

The project consists of three Verilog modules.

| Module | Functionality |
|---|---|
| `tff` | Implements the T flip-flop |
| `binary_4bit_downcnt` | Connects four T flip-flops to form the counter |
| `binary_4bit_downcnt_tb` | Generates clock, reset and monitors counter outputs |

### 4.1 T Flip-Flop Module

The T flip-flop uses positive-edge-triggered clocking and asynchronous active-high reset.

**Boolean Expression:**

```text
Q_next = T XOR Q
```

```verilog
module tff (
    output reg q,
    input t, clk, rst
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        q <= 1'b0;
    else if (t)
        q <= ~q;
end

endmodule
```

### 4.2 4-Bit Binary Down Counter Module

Four T flip-flops are instantiated and connected in a ripple configuration.

```verilog
module binary_4bit_downcnt (
    output [3:0] q,
    input clk, rst
);

tff tff0 (q[0], 1'b1, clk, rst);
tff tff1 (q[1], 1'b1, q[0], rst);
tff tff2 (q[2], 1'b1, q[1], rst);
tff tff3 (q[3], 1'b1, q[2], rst);

endmodule
```

### 4.3 Testbench

The testbench generates a clock with a 10 ns period and applies an asynchronous reset.

The simulation runs for approximately 210 ns.

```verilog
module binary_4bit_downcnt_tb;

wire [3:0] q;
reg clk, rst;

binary_4bit_downcnt dut (
    .q(q),
    .clk(clk),
    .rst(rst)
);

initial
begin
    clk = 0;
    rst = 1;

    #10 rst = 0;
    #200 $finish;
end

always #5 clk = ~clk;

initial
begin
    $monitor(
        "Time=%0t Reset=%b Count=%b(%d)",
        $time, rst, q, q
    );
end

endmodule
```

## 5. Simulation Environment

The design is simulated using Synopsys VCS, and waveform analysis is performed using Synopsys Verdi.

### 5.1 Simulation Workflow

```text
       Verilog RTL Design
               |
               v
          T Flip-Flop
               |
               v
       4-Bit Down Counter
               |
               v
          Testbench
               |
               v
          Synopsys VCS
               |
               v
        RTL Simulation
               |
               v
         FSDB Database
               |
               v
         Synopsys Verdi
               |
               v
        Waveform Analysis
```

### 5.2 VCS Compilation

Compile the RTL design and testbench using:

```bash
vcs -full64 -debug_access+all \
tff.v \
binary_4bit_downcnt.v \
binary_4bit_downcnt_tb.v \
-o simv
```

If all modules are maintained in a single Verilog file, compile that file along with the testbench instead.

### 5.3 Execute Simulation

```bash
./simv
```

The `$monitor` statement displays the simulation time, reset status and counter value whenever a monitored signal changes.

### 5.4 FSDB Waveform Generation

To generate an FSDB waveform, add the following commands inside the testbench:

```verilog
initial begin
    $fsdbDumpfile("inter_2.fsdb");
    $fsdbDumpvars(0, binary_4bit_downcnt_tb);
end
```

Ensure that the appropriate Verdi FSDB PLI integration is configured during VCS compilation.

### 5.5 Open FSDB in Synopsys Verdi

Use the following command to open the generated waveform:

```bash
verdi -ssf inter_2.fsdb &
```

The waveform can be explored using the Verdi waveform viewer.

## 6. Simulation Results

The simulation waveform is analyzed using Synopsys Verdi to observe the behavior of the asynchronous binary down counter.

### 6.1 Waveform Signals

The following signals are observed during simulation:

| Signal | Width | Description |
|---|---:|---|
| `clk` | 1 bit | External clock |
| `rst` | 1 bit | Asynchronous active-high reset |
| `q[3:0]` | 4 bits | Counter output |
| `dut` | Hierarchy | Counter module instance |

### 6.2 Verdi Waveform Screenshot

The following screenshot shows the design hierarchy, RTL source code and simulation waveforms in Synopsys Verdi.

![4-Bit Binary Down Counter Verdi Waveform](screenshots/4BITBINARYDOWNCOUNTER.png)

### 6.3 Verification Observations

- Asynchronous reset initializes all four flip-flop outputs to `0000`.
- Reset is deasserted after 10 ns.
- The external clock has a 10 ns period.
- Each T flip-flop toggles when its respective clock input experiences a positive edge.
- The cascaded flip-flop behavior can be inspected through the waveform.
- The actual counter sequence should be compared with the intended binary down-counting sequence.

**Verification note:** A successful compilation and simulation do not by themselves establish correct down-counter functionality. Verify the complete output sequence and rollover behavior before declaring functional verification successful.

## 7. Tools and Technologies

| Tool / Technology | Purpose |
|---|---|
| Verilog HDL | RTL design implementation |
| Synopsys VCS | RTL compilation and functional simulation |
| Synopsys Verdi | Waveform visualization and debugging |
| FSDB | Simulation waveform database |
| Git | Version control |
| GitHub | Source code management and documentation |

## 8. Key Learning Outcomes

Through this project, the following concepts are explored:

- Sequential circuit design using Verilog HDL.
- T flip-flop operation and toggle functionality.
- Asynchronous active-high reset.
- Positive-edge-triggered flip-flops.
- Ripple counter architecture.
- Binary down-counting operation.
- Hierarchical module instantiation.
- Testbench development and simulation.
- RTL functional verification using Synopsys VCS.
- Waveform analysis and debugging using Synopsys Verdi.
- FSDB waveform generation and inspection.

## 9. Future Enhancements

Potential extensions to this project include:

- Designing 8-bit and 16-bit asynchronous down counters.
- Implementing a synchronous binary down counter.
- Developing an up/down counter with direction control.
- Adding a counter enable signal.
- Comparing synchronous and asynchronous counter architectures.
- Performing RTL synthesis and timing analysis.
- Evaluating propagation delay in ripple counters.
- Implementing parameterized counter architectures.

## 10. Repository Structure

```text
4-bit-binary-down-counter/
│
├── tff.v
│   └── T flip-flop RTL
│
├── binary_4bit_downcnt.v
│   └── 4-bit down counter RTL
│
├── binary_4bit_downcnt_tb.v
│   └── Simulation testbench
│
├── screenshots/
│   └── 4BITBINARYDOWNCOUNTER.png
│
├── README.md
│
└── .gitignore
```

Generated simulation executables, temporary compilation directories and waveform databases can be excluded from version control using `.gitignore`.

## 11. Author

**SANTHOSH KUMAR N A**

RTL Design | Digital Design | VLSI Engineering

- GitHub: [Your GitHub Profile](https://github.com/your-username)
- LinkedIn: [Your LinkedIn Profile](https://linkedin.com/in/your-profile)

## 12. License

This project is intended for educational purposes and digital design learning.

You are welcome to explore, modify and extend the implementation with appropriate attribution.

---

<p align="center">
  <b>Designed with Verilog HDL | Simulated using Synopsys VCS | Analyzed using Synopsys Verdi</b>
</p>

<p align="center">
  ⭐ If you find this project useful, consider starring the repository!
</p>

---

## GitHub Topics

verilog · verilog-hdl · binary-down-counter · t-flip-flop · ripple-counter · vlsi · rtl-design · digital-electronics · sequential-circuits · synopsys-vcs · synopsys-verdi · rtl-verification · fsdb
