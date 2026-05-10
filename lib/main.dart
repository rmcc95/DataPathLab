import 'package:flutter/material.dart';

void main() {
  runApp(const DataPathLabApp());
}

class DataPathLabApp extends StatelessWidget {
  const DataPathLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DataPathLab',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0F1C),
      ),
      home: const HomeScreen(),
    );
  }
}

////////////////////////////////////////////////////////////
/// MAIN SCREEN WITH NAVIGATION
////////////////////////////////////////////////////////////

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<String> titles = [
    "DataPathLab",
    "Instruction Simulator",
    "Component Explorer",
  ];

  final screens = const [
    HomeContent(),
    SimulatorScreen(),
    ComponentExplorerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(titles[currentIndex]),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => currentIndex = 0),
              ),
            ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// HOME SCREENS
////////////////////////////////////////////////////////////

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan.withOpacity(0.1),
              ),
              child: const Icon(Icons.memory, color: Colors.cyan, size: 32),
            ),
            const SizedBox(height: 20),
            const Text(
              "DataPathLab",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Simulate MIPS single cycle processor\ndatapath design interactively",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            FeatureCard(
              title: "Instruction Simulator",
              subtitle: "Simulate ADD, LW, and SW in real-time",
              icon: Icons.memory,
              gradient: const LinearGradient(
                  colors: [Color(0xFF0F5132), Color(0xFF145A32)]),
              onTap: () {
                final s = context.findAncestorStateOfType<_HomeScreenState>();
                s?.setState(() => s.currentIndex = 1);
              },
            ),
            FeatureCard(
              title: "Component Explorer",
              subtitle: "Deep-dive into every datapath component",
              icon: Icons.layers,
              gradient: const LinearGradient(
                  colors: [Color(0xFF3D2C5A), Color(0xFF2A1F3D)]),
              onTap: () {
                final s = context.findAncestorStateOfType<_HomeScreenState>();
                s?.setState(() => s.currentIndex = 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
// FEATURE CARDS
////////////////////////////////////////////////////////////

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: gradient,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(subtitle,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
// BOTTOM NAV BAR
////////////////////////////////////////////////////////////

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items  = [Icons.home, Icons.memory, Icons.layers];
    final labels = ["Home", "Simulate", "Components"];

    return Container(
      color: const Color(0xFF0E1525),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[index],
                        color: isSelected ? Colors.cyan : Colors.grey),
                    const SizedBox(height: 4),
                    Text(labels[index],
                        style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.cyan : Colors.grey)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
// COMPONENT EXPLORER DATA
///////////////////////////////////////////////////////////

class ComponentInfo {
  final String name;
  final String shortDesc;
  final String fullDesc;
  final Color color;
  final IconData icon;
  final List<String> controlledBy;
  const ComponentInfo({
    required this.name,
    required this.shortDesc,
    required this.fullDesc,
    required this.color,
    required this.icon,
    required this.controlledBy,
  });
}

const _components = [
  ComponentInfo(
    name: "Program Counter (PC)",
    shortDesc: "Holds the address of the current instruction.",
    fullDesc:
        "The Program Counter is a 32-bit register that stores the memory address of the instruction currently being executed. At the end of each clock cycle it updates to the next instruction address — normally PC+4(See add4).",
    color: Color(0xFF00BCD4),
    icon: Icons.bookmark,
    controlledBy: ["PCSrc. Selects next instruction, or branch target address."],
  ),
  ComponentInfo(
    name: "Add +4",
    shortDesc: "Computes the address of the next instruction.",
    fullDesc:
        "A dedicated adder that takes the current PC value and adds 4 (Why 4? All MIPS instructions are 32 bits wide).",
    color: Color(0xFF00BCD4),
    icon: Icons.add_circle_outline,
    controlledBy: ["No control signals. Just adds 4"],
  ),
  ComponentInfo(
    name: "Instruction Memory",
    shortDesc: "Stores the program. Outputs the instruction at the given address.",
    fullDesc:
        "A read-only memory block that holds program instructions. Given a 32-bit address from the PC, it outputs the full 32-bit instruction on that clock cycle.",
    color: Color(0xFF7C4DFF),
    icon: Icons.storage,
    controlledBy: ["No control signals."],
  ),
  ComponentInfo(
    name: "Control Unit",
    shortDesc: "Decodes the 6-bit opcode and drives all control signals.",
    fullDesc:
        "The Control Unit reads the 6-bit opcode from the instruction and generates control signals that tell every other component what to do. There are 7 MIPS control signals in total:\nRegDst: Selects which register is being written to.\nRegWrite: Enables writing to the register file (load instructions)\nMemWrite: Enables writing to data memory (store instructions)\nMemtoReg: This determines whether data written to the register file is coming from the ALU('0') or coming from data memory ('1').\nMemRead: Enables memory read (load instructions)\nPCSrc: Chooses between 'PC +4' and a branch target address.\nALUOp: Determines which ALU operation is going to be done.\nALUsrc: Determines if an instruction is I-type('1') or R-type('0')",
    color: Color(0xFFE53935),
    icon: Icons.tune,
    controlledBy: ["Nothing — this IS the controller"],
  ),
  ComponentInfo(
    name: "Register File",
    shortDesc: "32 general-purpose 32-bit registers.",
    fullDesc:
        "The Register File contains all 32 MIPS general-purpose registers (Labeled 0 - 31). It supports two simultaneous reads and one write per clock cycle.",
    color: Color(0xFF43A047),
    icon: Icons.table_chart,
    controlledBy: ["RegWrite (enables write)", "RegDst (selects which register to write to)"],
  ),
  ComponentInfo(
    name: "ALU",
    shortDesc: "Arithmetic Logic Unit: add, subtract, AND, OR, etc.",
    fullDesc:
        "The Arithmetic Logic Unit performs all of the math and logic operations. For R-type instructions it adds or subtracts register values. For I-type instructions (lw/sw) it computes the memory address. For branches (beq) it subtracts the two register values and checks the zero flag.",
    color: Color(0xFFFFD600),
    icon: Icons.calculate,
    controlledBy: ["ALUSrc (selects the second operand for the ALU)"],
  ),
  ComponentInfo(
    name: "Data Memory",
    shortDesc: "Basically RAM. Stores program data.",
    fullDesc:
        "Data Memory is the main memory of the processor. It is separate from Instruction Memory. Only active during load (lw) and store (sw) instructions.",
    color: Color(0xFF7C4DFF),
    icon: Icons.memory,
    controlledBy: ["MemRead (enables read)", "MemWrite (enables write)"],
  ),
  ComponentInfo(
    name: "Sign Extend",
    shortDesc: "Extends a 16-bit immediate to 32 bits, preserving the sign.",
    fullDesc:
        "I-type instructions (lw, sw, addi, beq) encode a 16-bit immediate value in the lower half of the instruction. In order for the ALU to use it, this must be extended to 32 bits.",
    color: Color(0xFF00BCD4),
    icon: Icons.expand,
    controlledBy: ["No control signals"],
  ),
  ComponentInfo(
    name: "Multiplexers (MUX)",
    shortDesc: "Selects between two signals based on a control input.",
    fullDesc:
        "A multiplexer (MUX) takes multiple inputs and picks one of them to send forward, based on a control signal.",
    color: Color(0xFFFF8F00),
    icon: Icons.call_split,
    controlledBy: [],
  ),
];

////////////////////////////////////////////////////////////
// COMPONENT EXPLORER SCREEN
////////////////////////////////////////////////////////////

class ComponentExplorerScreen extends StatelessWidget {
  const ComponentExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      itemCount: _components.length,
      itemBuilder: (ctx, i) => _ComponentCard(info: _components[i]),
    );
  }
}

class _ComponentCard extends StatefulWidget {
  final ComponentInfo info;
  const _ComponentCard({required this.info});

  @override
  State<_ComponentCard> createState() => _ComponentCardState();
}

class _ComponentCardState extends State<_ComponentCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final col  = info.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: col.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded ? col.withOpacity(0.6) : col.withOpacity(0.25),
          width: _expanded ? 1.5 : 1,
        ),
        boxShadow: _expanded
            ? [BoxShadow(color: col.withOpacity(0.12), blurRadius: 12)]
            : [],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: col.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: col.withOpacity(0.4)),
                  ),
                  child: Icon(info.icon, color: col, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(info.name,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: col)),
                      const SizedBox(height: 3),
                      Text(info.shortDesc,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.white54)),
                    ],
                  ),
                ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: col.withOpacity(0.6),
                ),
              ]),
            ),
          ),

          if (_expanded) ...[
            Divider(color: col.withOpacity(0.2), height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(info.fullDesc,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          height: 1.5)),
                  const SizedBox(height: 14),

                  if (info.controlledBy.isNotEmpty) ...[
                    _SectionLabel("CONTROLLED BY", Colors.amber),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: info.controlledBy
                          .map((s) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: Colors.amber.withOpacity(0.4)),
                                ),
                                child: Text(s,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.amber)),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: color.withOpacity(0.7),
            letterSpacing: 1.0));
  }
}

////////////////////////////////////////////////////////////
// MIPS DATAPATH SIMULATOR
////////////////////////////////////////////////////////////

enum ComponentId {
  pc,
  add4,
  iMem,
  controlUnit,
  regFile,
  alu,
  dataMem,
  mux1,
  mux2,
  mux3,
  signExtend,
}

enum WireId {
  pcToIMem,
  pcToAdd4,
  add4ToPC,
  iMemToControl,
  iMemToRegFile,
  iMemToMux1,
  iMemToSignExt,
  mux1ToRegFile,
  regFileToAlu,
  regFileToMux2,
  signExtToMux2,
  mux2ToAlu,
  aluToDataMem,
  aluToMux3,
  dataMemToMux3,
  mux3ToRegFile,
  controlToAll,
}

enum Sig { zero, one, x }

class ControlSignals {
  final Sig regDst;
  final Sig aluSrc;
  final Sig memToReg;
  final Sig regWrite;
  final Sig memRead;
  final Sig memWrite;
  final Sig pcSrc;

  const ControlSignals({
    required this.regDst,
    required this.aluSrc,
    required this.memToReg,
    required this.regWrite,
    required this.memRead,
    required this.memWrite,
    required this.pcSrc,
  });

  static const inactive = ControlSignals(
    regDst: Sig.x, aluSrc: Sig.x, memToReg: Sig.x,
    regWrite: Sig.x, memRead: Sig.x, memWrite: Sig.x,
    pcSrc: Sig.x,
  );
}

class DatapathStep {
  final String title;
  final String description;
  final List<ComponentId> activeComponents;
  final List<WireId> activeWires;
  final ControlSignals signals;

  const DatapathStep({
    required this.title,
    required this.description,
    required this.activeComponents,
    required this.activeWires,
    this.signals = ControlSignals.inactive,
  });
}

////ADD///////////////////////////////////////////
const addSteps = [
  DatapathStep(
    title: "Instruction Fetch",
    description:
        "PC sends its address to Instruction Memory. The instruction is fetched and Add+4 computes the next PC value.",
    activeComponents: [ComponentId.pc, ComponentId.add4, ComponentId.iMem],
    activeWires: [WireId.pcToIMem, WireId.pcToAdd4, WireId.add4ToPC],
  ),
  DatapathStep(
    title: "Decode & Register Read",
    description:
        "Control Unit decodes the opcode and sets control signals. Register File reads \$s1 (rs) and \$s2 (rt).",
    activeComponents: [
      ComponentId.controlUnit, ComponentId.regFile,
      ComponentId.iMem, ComponentId.mux1,
    ],
    activeWires: [
      WireId.iMemToControl, WireId.iMemToRegFile,
      WireId.iMemToMux1, WireId.controlToAll,
    ],
    signals: ControlSignals(
      regDst: Sig.one, aluSrc: Sig.zero, memToReg: Sig.zero,
      regWrite: Sig.one, memRead: Sig.zero, memWrite: Sig.zero, pcSrc: Sig.zero,
    ),
  ),
  DatapathStep(
    title: "Execute (ALU)",
    description:
        "ALU adds \$s1 + \$s2. ALUSrc=0 selects the register operand.",
    activeComponents: [ComponentId.regFile, ComponentId.alu, ComponentId.mux2],
    activeWires: [WireId.regFileToAlu, WireId.regFileToMux2, WireId.mux2ToAlu],
    signals: ControlSignals(
      regDst: Sig.one, aluSrc: Sig.zero, memToReg: Sig.zero,
      regWrite: Sig.one, memRead: Sig.zero, memWrite: Sig.zero, pcSrc: Sig.zero,
    ),
  ),
  DatapathStep(
    title: "Write Back",
    description:
        "ALU result written to \$t0. MemtoReg=0 selects ALU result. RegDst=1 selects rd field.",
    activeComponents: [ComponentId.regFile, ComponentId.mux3, ComponentId.alu],
    activeWires: [WireId.aluToMux3, WireId.mux3ToRegFile],
    signals: ControlSignals(
      regDst: Sig.one, aluSrc: Sig.zero, memToReg: Sig.zero,
      regWrite: Sig.one, memRead: Sig.zero, memWrite: Sig.zero, pcSrc: Sig.zero,
    ),
  ),
];

////LW ///////////////////////////////////////////
const lwSteps = [
  DatapathStep(
    title: "Instruction Fetch",
    description: "PC sends address to Instruction Memory. The lw instruction is fetched.",
    activeComponents: [ComponentId.pc, ComponentId.add4, ComponentId.iMem],
    activeWires: [WireId.pcToIMem, WireId.pcToAdd4, WireId.add4ToPC],
  ),
  DatapathStep(
    title: "Decode & Register Read",
    description:
        "Control sets MemRead=1, MemtoReg=1, ALUSrc=1, RegDst=0, RegWrite=1. Base register is read. Offset is sign-extended.",
    activeComponents: [
      ComponentId.controlUnit, ComponentId.regFile,
      ComponentId.iMem, ComponentId.signExtend,
    ],
    activeWires: [
      WireId.iMemToControl, WireId.iMemToRegFile,
      WireId.iMemToSignExt, WireId.controlToAll,
    ],
    signals: ControlSignals(
      regDst: Sig.zero, aluSrc: Sig.one, memToReg: Sig.one,
      regWrite: Sig.one, memRead: Sig.one, memWrite: Sig.zero, pcSrc: Sig.zero,
    ),
  ),
  DatapathStep(
    title: "Execute (ALU)",
    description:
        "ALU computes base + sign-extended offset. ALUSrc=1 selects the immediate.",
    activeComponents: [
      ComponentId.regFile, ComponentId.alu,
      ComponentId.mux2, ComponentId.signExtend,
    ],
    activeWires: [WireId.regFileToAlu, WireId.signExtToMux2, WireId.mux2ToAlu],
    signals: ControlSignals(
      regDst: Sig.zero, aluSrc: Sig.one, memToReg: Sig.one,
      regWrite: Sig.one, memRead: Sig.one, memWrite: Sig.zero, pcSrc: Sig.zero,
    ),
  ),
  DatapathStep(
    title: "Memory Read",
    description: "Data Memory reads from the computed address. MemRead=1 enables the read.",
    activeComponents: [ComponentId.alu, ComponentId.dataMem],
    activeWires: [WireId.aluToDataMem],
    signals: ControlSignals(
      regDst: Sig.zero, aluSrc: Sig.one, memToReg: Sig.one,
      regWrite: Sig.one, memRead: Sig.one, memWrite: Sig.zero, pcSrc: Sig.zero,
    ),
  ),
  DatapathStep(
    title: "Write Back",
    description:
        "Memory output written to destination register. MemtoReg=1 selects memory data path.",
    activeComponents: [ComponentId.dataMem, ComponentId.mux3, ComponentId.regFile],
    activeWires: [WireId.dataMemToMux3, WireId.mux3ToRegFile],
    signals: ControlSignals(
      regDst: Sig.zero, aluSrc: Sig.one, memToReg: Sig.one,
      regWrite: Sig.one, memRead: Sig.one, memWrite: Sig.zero, pcSrc: Sig.zero,
    ),
  ),
];

////SW/////////////////////////////////////////////////////////
const swSteps = [
  DatapathStep(
    title: "Instruction Fetch",
    description: "PC sends address to Instruction Memory. The sw instruction is fetched.",
    activeComponents: [ComponentId.pc, ComponentId.add4, ComponentId.iMem],
    activeWires: [WireId.pcToIMem, WireId.pcToAdd4, WireId.add4ToPC],
  ),
  DatapathStep(
    title: "Decode & Register Read",
    description:
        "Control sets MemWrite=1, ALUSrc=1, RegWrite=0. Base and source registers are read. Offset is sign-extended.",
    activeComponents: [
      ComponentId.controlUnit, ComponentId.regFile,
      ComponentId.iMem, ComponentId.signExtend,
    ],
    activeWires: [
      WireId.iMemToControl, WireId.iMemToRegFile,
      WireId.iMemToSignExt, WireId.controlToAll,
    ],
    signals: ControlSignals(
      regDst: Sig.x, aluSrc: Sig.one, memToReg: Sig.x,
      regWrite: Sig.zero, memRead: Sig.zero, memWrite: Sig.one, pcSrc: Sig.zero,
    ),
  ),
  DatapathStep(
    title: "Execute (ALU)",
    description:
        "ALU computes base + offset for the store address. ALUSrc=1 selects the sign-extended immediate.",
    activeComponents: [
      ComponentId.regFile, ComponentId.alu,
      ComponentId.mux2, ComponentId.signExtend,
    ],
    activeWires: [WireId.regFileToAlu, WireId.signExtToMux2, WireId.mux2ToAlu],
    signals: ControlSignals(
      regDst: Sig.x, aluSrc: Sig.one, memToReg: Sig.x,
      regWrite: Sig.zero, memRead: Sig.zero, memWrite: Sig.one, pcSrc: Sig.zero,
    ),
  ),
  DatapathStep(
    title: "Memory Write",
    description:
        "Data Memory writes \$t0 to the computed address. MemWrite=1. No register write back.",
    activeComponents: [ComponentId.alu, ComponentId.dataMem, ComponentId.regFile],
    activeWires: [WireId.aluToDataMem, WireId.regFileToMux2],
    signals: ControlSignals(
      regDst: Sig.x, aluSrc: Sig.one, memToReg: Sig.x,
      regWrite: Sig.zero, memRead: Sig.zero, memWrite: Sig.one, pcSrc: Sig.zero,
    ),
  ),
];

////////////////////////////////////////////////////////////
// LAYOUT
////////////////////////////////////////////////////////////

const double _cW = 1000;
const double _cH = 600;

const _rects = <ComponentId, Rect>{//draws the components
  ComponentId.pc:          Rect.fromLTWH(30,  260, 90,  70),
  ComponentId.add4:        Rect.fromLTWH(220, 155, 90,  60),
  ComponentId.iMem:        Rect.fromLTWH(220, 255, 110, 85),
  ComponentId.controlUnit: Rect.fromLTWH(430,  75, 115, 70),
  ComponentId.regFile:     Rect.fromLTWH(430, 240, 125, 95),
  ComponentId.mux1:        Rect.fromLTWH(392, 358, 34,  62),
  ComponentId.signExtend:  Rect.fromLTWH(430, 428, 110, 50),
  ComponentId.mux2:        Rect.fromLTWH(622, 298, 34,  62),
  ComponentId.alu:         Rect.fromLTWH(705, 238, 92,  105),
  ComponentId.dataMem:     Rect.fromLTWH(865, 242, 112, 95),
  ComponentId.mux3:        Rect.fromLTWH(1022,298, 34,  62),
};

const _colors = <ComponentId, Color>{
  ComponentId.pc:          Color(0xFF00BCD4),
  ComponentId.add4:        Color(0xFF00BCD4),
  ComponentId.iMem:        Color(0xFF7C4DFF),
  ComponentId.controlUnit: Color(0xFFE53935),
  ComponentId.regFile:     Color(0xFF43A047),
  ComponentId.mux1:        Color(0xFFFF8F00),
  ComponentId.signExtend:  Color(0xFF00BCD4),
  ComponentId.mux2:        Color(0xFFFF8F00),
  ComponentId.alu:         Color(0xFFFFD600),
  ComponentId.dataMem:     Color(0xFF7C4DFF),
  ComponentId.mux3:        Color(0xFFFF8F00),
};

////////////////////////////////////////////////////////////
// SIMULATOR SCREEN
////////////////////////////////////////////////////////////

class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  int _instrIndex = 0;
  int _step = -1;

  static const _instructions = [
    (label: 'ADD', display: 'add \$t0, \$s1, \$s2', steps: addSteps),
    (label: 'LW',  display: 'lw  \$t0, 4(\$s1)',    steps: lwSteps),
    (label: 'SW',  display: 'sw  \$t0, 4(\$s1)',     steps: swSteps),
  ];

  List<DatapathStep> get _steps => _instructions[_instrIndex].steps;
  DatapathStep? get _current => _step >= 0 ? _steps[_step] : null;

  bool _isActive(ComponentId id) =>
      _current?.activeComponents.contains(id) ?? false;

  void _start() => setState(() => _step = 0);
  void _next()  => setState(() { if (_step < _steps.length - 1) _step++; });
  void _prev()  => setState(() { if (_step > 0) _step--; });
  void _reset() => setState(() => _step = -1);

  @override
  Widget build(BuildContext context) {
    final instr = _instructions[_instrIndex];

    return Column(
      children: [
        _InstrDropdown(
          label:   instr.label,
          display: instr.display,
          instructions: _instructions
              .map((e) => (label: e.label, display: e.display))
              .toList(),
          onChanged: (i) => setState(() {
            _instrIndex = i;
            _step = -1;
          }),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1321),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LayoutBuilder(builder: (ctx, box) {
                final sx    = box.maxWidth  / _cW;
                final sy    = box.maxHeight / _cH;
                final scale = sx < sy ? sx : sy;
                final dx    = (box.maxWidth  - _cW * scale) / 2;
                final dy    = (box.maxHeight - _cH * scale) / 2;

                return Stack(children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WirePainter(
                        activeWires: _current?.activeWires ?? [],
                        scale: scale, dx: dx, dy: dy,
                      ),
                    ),
                  ),
                  ..._rects.entries.map((e) {
                    final id  = e.key;
                    final r   = e.value;
                    final col = _colors[id]!;
                    return Positioned(
                      left:   dx + r.left   * scale,
                      top:    dy + r.top    * scale,
                      width:  r.width  * scale,
                      height: r.height * scale,
                      child: _ComponentBox(
                        label:  _compLabel(id),
                        color:  col,
                        active: _isActive(id),
                        isAlu:  id == ComponentId.alu,
                        isMux:  id == ComponentId.mux1 ||
                                id == ComponentId.mux2 ||
                                id == ComponentId.mux3,
                      ),
                    );
                  }),
                ]);
              }),
            ),
          ),
        ),
        _ControlSignalTable(signals: _current?.signals),
        if (_current != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Column(children: [
              Text(
                "Step ${_step + 1}/${_steps.length}: ${_current!.title}",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent),
              ),
              const SizedBox(height: 4),
              Text(
                _current!.description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 6),
            ]),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 14, top: 2),
          child: _step < 0
              ? ElevatedButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start Simulation"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CtrlBtn(icon: Icons.skip_previous, label: "Reset",
                        onTap: _reset),
                    const SizedBox(width: 12),
                    _CtrlBtn(icon: Icons.arrow_back, label: "Prev",
                        onTap: _step > 0 ? _prev : null),
                    const SizedBox(width: 12),
                    _CtrlBtn(
                      icon: _step < _steps.length - 1
                          ? Icons.arrow_forward : Icons.check,
                      label: _step < _steps.length - 1 ? "Next" : "Done",
                      onTap: _step < _steps.length - 1 ? _next : _reset,
                      primary: true,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  String _compLabel(ComponentId id) => switch (id) {
        ComponentId.pc          => 'PC',
        ComponentId.add4        => 'Add\n(+4)',
        ComponentId.iMem        => 'Instruction\nMemory',
        ComponentId.controlUnit => 'Control\nUnit',
        ComponentId.regFile     => 'Register\nFile',
        ComponentId.mux1        => 'M',
        ComponentId.mux2        => 'M',
        ComponentId.mux3        => 'M',
        ComponentId.signExtend  => 'Sign\nExtend',
        ComponentId.alu         => 'ALU',
        ComponentId.dataMem     => 'Data\nMemory',
      };
}

////////////////////////////////////////////////////////////
/// CONTROL SIGNAL TABLE
////////////////////////////////////////////////////////////

class _ControlSignalTable extends StatelessWidget {
  final ControlSignals? signals;
  const _ControlSignalTable({this.signals});

  @override
  Widget build(BuildContext context) {
    final sigs = signals;
    final entries = sigs == null ? <(String, String, Sig)>[] : [
      ('RegDst',   'Selects destination register being written to',          sigs.regDst),
      ('ALUSrc',   'Selects 2nd ALU operand:\n0 = register, 1 = immediate', sigs.aluSrc),
      ('MemtoReg', 'Selects write-back value:\n0 = ALU result, 1 = memory data', sigs.memToReg),
      ('RegWrite', 'Enables write to register file:\n1 = write',             sigs.regWrite),
      ('MemRead',  'Enables memory read:\n1 = read data memory',             sigs.memRead),
      ('MemWrite', 'Enables memory write:\n1 = write to data memory',        sigs.memWrite),
      ('PCSrc',    'Selects next PC:\n0 = PC+4, 1 = branch target',          sigs.pcSrc),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1321),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.settings_input_component,
                size: 13, color: Colors.white38),
            const SizedBox(width: 6),
            const Text("Control Signals",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white38,
                    letterSpacing: 0.8)),
            const Spacer(),
            if (sigs == null)
              const Text(" No active instruction. Select an instruction step to view control signals.",
                  style: TextStyle(fontSize: 10, color: Colors.white24)),
          ]),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: entries.map((e) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Tooltip(
                  message: e.$2,
                  preferBelow: false,
                  child: _SignalChip(
                      label: e.$1, value: e.$3, active: sigs != null),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  final String label;
  final Sig value;
  final bool active;
  const _SignalChip({required this.label, required this.value, required this.active});

  @override
  Widget build(BuildContext context) {
    final isX   = value == Sig.x || !active;
    final isOne = value == Sig.one && active;
    final bg    = isX ? Colors.white.withOpacity(0.04)
                      : isOne ? Colors.cyan.withOpacity(0.18)
                               : Colors.white.withOpacity(0.07);
    final border = isX ? Colors.white12
                       : isOne ? Colors.cyanAccent.withOpacity(0.7)
                                : Colors.white24;
    final valText  = isX ? 'X' : (isOne ? '1' : '0');
    final valColor = isX ? Colors.white24
                         : isOne ? Colors.cyanAccent : Colors.white54;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
        boxShadow: isOne
            ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.15), blurRadius: 6)]
            : [],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(label,
            style: TextStyle(
                fontSize: 9,
                color: isX ? Colors.white24 : Colors.white60,
                letterSpacing: 0.3)),
        const SizedBox(height: 3),
        Text(valText,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: valColor)),
      ]),
    );
  }
}

////////////////////////////////////////////////////////////
/// WIRE PAINTER
////////////////////////////////////////////////////////////

class _WirePainter extends CustomPainter {
  final List<WireId> activeWires;
  final double scale, dx, dy;

  const _WirePainter({
    required this.activeWires,
    required this.scale,
    required this.dx,
    required this.dy,
  });

  bool _a(WireId w) => activeWires.contains(w);
  Offset _s(double x, double y) => Offset(dx + x * scale, dy + y * scale);

  Paint _paint(WireId w) => Paint()
    ..color       = _a(w) ? Colors.cyanAccent : Colors.white24
    ..strokeWidth = (_a(w) ? 2.5 : 1.5) * scale
    ..style       = PaintingStyle.stroke
    ..strokeCap   = StrokeCap.round;

  void _line(Canvas c, WireId w, Offset a, Offset b) => c.drawLine(a, b, _paint(w));

  void _poly(Canvas c, WireId w, List<Offset> pts) {
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 1; i < pts.length; i++) path.lineTo(pts[i].dx, pts[i].dy);
    c.drawPath(path, _paint(w));
  }

  @override
  void paint(Canvas canvas, Size size) {
    _line(canvas, WireId.pcToIMem,        _s(120, 295), _s(220, 295));
    _poly(canvas, WireId.pcToAdd4,       [_s(75, 260), _s(75, 185), _s(220, 185)]);
    _poly(canvas, WireId.add4ToPC,       [_s(310,185), _s(375,185), _s(375,228), _s(15,228), _s(15,295), _s(30,295)]);
    _poly(canvas, WireId.iMemToControl,  [_s(330,268), _s(390,268), _s(390,110), _s(430,110)]);
    _poly(canvas, WireId.iMemToRegFile,  [_s(330,290), _s(395,290), _s(395,272), _s(430,272)]);
    _poly(canvas, WireId.iMemToMux1,     [_s(330,310), _s(372,310), _s(372,372), _s(392,372)]);
    _poly(canvas, WireId.iMemToSignExt,  [_s(330,325), _s(358,325), _s(358,453), _s(430,453)]);
    _poly(canvas, WireId.mux1ToRegFile,  [_s(426,389), _s(453,389), _s(453,335)]);
    _line(canvas, WireId.regFileToAlu,    _s(555,268), _s(705,268));
    _poly(canvas, WireId.regFileToMux2,  [_s(555,300), _s(605,300), _s(605,313), _s(622,313)]);
    _poly(canvas, WireId.signExtToMux2,  [_s(540,453), _s(608,453), _s(608,345), _s(622,345)]);
    _line(canvas, WireId.mux2ToAlu,       _s(656,329), _s(705,300));
    _line(canvas, WireId.aluToDataMem,    _s(797,290), _s(865,290));
    _poly(canvas, WireId.aluToMux3,       [_s(797,272), _s(845,272), _s(845,218), _s(1039,218), _s(1039,300)]);
    _line(canvas, WireId.dataMemToMux3,  _s(977,310), _s(1022,335));
    _poly(canvas, WireId.mux3ToRegFile, [_s(1056,329), _s(1075,329), _s(1075,545), _s(492,545), _s(492,335)]);

    if (_a(WireId.controlToAll)) {
      final p = Paint()
        ..color       = Colors.cyanAccent.withOpacity(0.55)
        ..strokeWidth = 1.2 * scale
        ..style       = PaintingStyle.stroke;
      for (final id in [
        ComponentId.regFile, ComponentId.mux2,
        ComponentId.alu, ComponentId.dataMem, ComponentId.mux3,
      ]) {
        final r  = _rects[id]!;
        final cx = r.left + r.width / 2;
        _dashed(canvas, _s(cx, 145), _s(cx, r.top), p);
      }
    }
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 6.0, gap = 4.0;
    final total = (b - a).distance;
    final dir   = (b - a) / total;
    var dist = 0.0; var on = true;
    while (dist < total) {
      final next = (dist + (on ? dash : gap)).clamp(0.0, total);
      if (on) canvas.drawLine(a + dir * dist, a + dir * next, paint);
      dist = next; on = !on;
    }
  }

  @override
  bool shouldRepaint(covariant _WirePainter old) =>
      old.activeWires != activeWires || old.scale != scale;
}

////////////////////////////////////////////////////////////
/// COMPONENT BOX
////////////////////////////////////////////////////////////

class _ComponentBox extends StatelessWidget {
  final String label;
  final Color  color;
  final bool   active, isAlu, isMux;

  const _ComponentBox({
    required this.label, required this.color, required this.active,
    this.isAlu = false, this.isMux = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = active ? color : color.withOpacity(0.35);
    final fill   = active ? color.withOpacity(0.18) : color.withOpacity(0.05);
    final text   = active ? color : color.withOpacity(0.6);

    if (isAlu) {
      return CustomPaint(
        painter: _AluPainter(fill: fill, border: border),
        child: Center(child: Text('ALU',
            style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 13))),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(isMux ? 6 : 10),
        border: Border.all(color: border, width: active ? 2 : 1),
        boxShadow: active
            ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)] : [],
      ),
      child: Center(child: Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(color: text, fontWeight: FontWeight.bold,
              fontSize: isMux ? 11 : 12, height: 1.3))),
    );
  }
}

class _AluPainter extends CustomPainter {
  final Color fill, border;
  const _AluPainter({required this.fill, required this.border});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height, ind = h * 0.22;
    final path = Path()
      ..moveTo(0, 0)      ..lineTo(w, ind)
      ..lineTo(w, h-ind)  ..lineTo(0, h)
      ..lineTo(0, h*0.6)  ..lineTo(w*0.35, h*0.5)
      ..lineTo(0, h*0.4)  ..close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(path, Paint()..color = border
        ..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _AluPainter old) =>
      old.fill != fill || old.border != border;
}

////////////////////////////////////////////////////////////
/// INSTRUCTION DROPDOWN
////////////////////////////////////////////////////////////

class _InstrDropdown extends StatelessWidget {
  final String label, display;
  final List<({String label, String display})> instructions;
  final void Function(int) onChanged;

  const _InstrDropdown({
    required this.label, required this.display,
    required this.instructions, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1321),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.cyan.withOpacity(0.4)),
          ),
          child: Text(label, style: const TextStyle(
              color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(display,
            style: const TextStyle(color: Colors.white70, fontSize: 13))),
        PopupMenuButton<int>(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          color: const Color(0xFF1A2333),
          onSelected: onChanged,
          itemBuilder: (_) => instructions.asMap().entries.map((e) =>
            PopupMenuItem(
              value: e.key,
              child: Row(children: [
                Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(e.value.label, textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.cyanAccent, fontSize: 11)),
                ),
                const SizedBox(width: 10),
                Text(e.value.display,
                    style: const TextStyle(color: Colors.white70)),
              ]),
            )).toList(),
        ),
      ]),
    );
  }
}

////////////////////////////////////////////////////////////
/// CONTROL BUTTON
////////////////////////////////////////////////////////////

class _CtrlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool primary;

  const _CtrlBtn({
    required this.icon, required this.label,
    required this.onTap, this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: primary ? Colors.cyan : const Color(0xFF1A2333),
        foregroundColor: primary ? Colors.black : Colors.white70,
        disabledBackgroundColor: const Color(0xFF111827),
        disabledForegroundColor: Colors.white24,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}