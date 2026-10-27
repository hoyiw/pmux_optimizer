#!/usr/bin/env python3
"""Generate a flat PMUX-heavy benchmark close to the competition size limit."""

from __future__ import annotations

import argparse
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("output", type=Path)
    parser.add_argument("--lanes", type=int, default=50)
    parser.add_argument("--branches", type=int, default=16)
    parser.add_argument("--width", type=int, default=32)
    args = parser.parse_args()

    if args.branches < 2 or args.branches > 32:
        parser.error("--branches must be in the range 2..32")
    if args.width < 1:
        parser.error("--width must be positive")

    data_ports = [f"    input wire [{args.width - 1}:0] d{i}" for i in range(args.branches)]
    idx_ports = [
        f"    input wire [4:0] idx{i}"
        for i in range(args.lanes)
    ]
    out_ports = [
        f"    output reg [{args.width - 1}:0] y{i}"
        for i in range(args.lanes)
    ]
    ports = "\n".join(
        [
            "module pmux_stress (",
            *[p + "," for p in data_ports + idx_ports],
            "    input wire [%d:0] seed," % (args.width - 1),
        ]
        + [p + ("," if i != len(out_ports) - 1 else "") for i, p in enumerate(out_ports)]
        + [");"]
    )

    lines = [ports]
    for lane in range(args.lanes):
        lines.append(f"    always @* begin")
        lines.append(f"        case (idx{lane})")
        for branch in range(args.branches):
            source = f"d{branch}"
            if lane % 4 == 1:
                source = f"({source} ^ seed)"
            elif lane % 4 == 2:
                source = f"{{({source} << {(lane % 3) + 1}), {source} >> ({args.width - ((lane % 3) + 1)})}}"
            elif lane % 4 == 3:
                source = f"({source} + {lane + 1})"
            lines.append(f"            5'd{branch}: y{lane} = {source};")
        lines.append(f"            default: y{lane} = seed ^ {lane + 1};")
        lines.append("        endcase")
        lines.append("    end")

    lines.append("endmodule")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text("\n".join(lines) + "\n", encoding="ascii")


if __name__ == "__main__":
    main()
