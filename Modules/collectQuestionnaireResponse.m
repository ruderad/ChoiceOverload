function [response, RT] = collectQuestionnaireResponse( ...
    window, Layout, P, T, questionFiles, startTime)

nQuestions = P.Questionnaire.nQuestions;
nScalePoints = P.Questionnaire.nScalePoints;

response = nan(1, nQuestions);
RT = nan(1, nQuestions);

answered = false(1, nQuestions);


%% Initial questionnaire display

drawQuestionnaire( ...
    P, T, Layout, questionFiles, response);

Screen('Flip', window);


%% Collect responses

while ~all(answered)

    [x, y, buttons] = GetMouse(window);

    if any(buttons)

        for question = 1:nQuestions

            for scalePoint = 1:nScalePoints

                rect = Layout.button(question, scalePoint, :);
                rect = rect(:)';

                if IsInRect(x, y, rect)

                    response(question) = scalePoint;
                    RT(question) = GetSecs - startTime;

                    answered(question) = true;

                    % Redraw with selected option highlighted
                    drawQuestionnaire( ...
                        P, T, Layout, questionFiles, response);

                    Screen('Flip', window);

                    break;

                end

            end

        end

    end


    %% Timeout

    if GetSecs - startTime >= P.Questionnaire.duration
        break;
    end

end

end