#include <stdio.h>
#include <stdlib.h>
#include <Yoga.h>

/* ----------------------------------------------------- */

static void print(YGNodeRef node);

/* ----------------------------------------------------- */

int main() {

  const YGConfigRef config = YGConfigNew();
  const YGNodeRef container = YGNodeNewWithConfig(config);
  const YGNodeRef item = YGNodeNewWithConfig(config);

  YGNodeInsertChild(container, item, 0);
  YGNodeStyleSetFlex(item, 0.5);
  YGNodeStyleSetAlignItems(container, YGAlignStretch);
    
  YGNodeCalculateLayout(container, 1280, 720, YGDirectionLTR);

  print(container);
  
  return 0;
}

/* ----------------------------------------------------- */

static void print(YGNodeRef node) {
  YGNodePrint(node, (YGPrintOptions)(YGPrintOptionsLayout|YGPrintOptionsStyle|YGPrintOptionsChildren));
  printf("\n");
}

/* ----------------------------------------------------- */
