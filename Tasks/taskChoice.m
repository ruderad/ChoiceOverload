function R = taskChoice(R, P, T, ChoiceSets)
ShowCursor;

%% ==============================================================
%  Choice Task
%  ==============================================================

Layout = makeChoiceLayout(P);

Layout = convertChoiceLayout( ...
    Layout, T.windowRect);


%% ==============================================================
%  Run Blocks
%  ==============================================================

blockOrder = P.Choice.blockOrder;

R.Choice.blockOrder = blockOrder;

for block = 1:numel(blockOrder)

    setSizeIndex = blockOrder(block);

    R.Choice.block(block) = runChoiceBlock( ...
        P, ...
        T, ...
        ChoiceSets{setSizeIndex}, ...
        Layout);

end

HideCursor;

end