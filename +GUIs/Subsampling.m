classdef Subsampling < GUIs.base
%SUBSAMPLING Screen designed to demostrate chroma subsampling
%
%   +GUIs/Subsampling.m
%   Part of 'MATLAB Image & Video Compression Demos'
%
%   The following screen demostrates the principles and reasoning behind
%   chroma subsampling to reduce visual redundancy.
%
%   Start a new screen by calling the class constructor:
%       `GUIs.Subsampling`
%   The constructor takes a 1st optional string argument, the name of the
%   file in the examples directory to load.
%       `GUIs.Subsampling('fruit.jpg')`
%   The second optional string argument is the name of the examples
%   directory to use:
%       `GUIs.Subsampling('fruit.jpg', '../examples')`
%
%   Licensed under the 3-clause BSD license, see 'License.m'
%   Copyright (c) 2011, Stephen Ierodiaconou, University of Bristol.
%   All rights reserved.

   properties
       hChannelSelect
       hChannelSelectText
       hShowChannelInColours

       hInterpolationSelect
       hInterpolationSelectText

       hSubsampleModeSelect
       hShowChannelUpsampledCheckBox
       
       hInputImage
       hSubsampledImagePixelCount
       hSubsampledImageAxes
       hSubsampledImage
       hShownImage
       
       hSelectedBlockPanel
       hSelectedBlockRectangle
       hSubsamplingModeImageAxes

       lastClickedBlockX
       lastClickedBlockY
       
       defaultSubsamplingMode
       subsamplingMode
       subsamplingModeImages
       interpolationMode
       showChannelInColour
       upsampleImage
   end

   methods
        function obj = Subsampling(fileName, examplesDirectory)

            if ~exist('examplesDirectory', 'var')
                examplesDirectory = 'examples/';
            end
            obj = obj@GUIs.base('Subsampling: Utilising Perceptual Redundancy', examplesDirectory);

            % default modes
            obj.defaultSubsamplingMode = [1 3 6];
            obj.channelToShow = 'all';
            obj.interpolationMode = 'nearest';
            obj.upsampleImage = {true true true};
            obj.showChannelInColour = false;

            % Show input image selection
            obj.createInputImageSelectComboBoxAndText([0.06 0.96 0.25 0.03], [0.06 0.91 0.2 0.03]);

            % Popup: Channel Selection
            obj.hChannelSelectText = obj.createTextElement([0.35 0.96 0.22 0.03], 'Channel type to show:', 11, 'on', 'white', obj.hExternalPanel, 'FontName', 'helvetica');

            obj.hChannelSelect = uicontrol('Style', 'popupmenu', ...
                                        'Parent', obj.hExternalPanel, ...
                                        'FontSize', 11, ...
                                        'FontName', 'arial',...
                                        'Units', 'Normalized', ...
                                        'Position',[0.4 0.93 0.25 0.03],...
                                        'String', 'All Channels/Whole Colour Image (Y+Cb+Cr Channels)|Luminance (Y Channel)|Chroma/Colour (Cb Channel)|Chroma/Colour (Cr Channel)',...
                                        'Callback', @(source, event)(obj.changeChannelOnDisplay(source)));

            obj.hShowChannelInColours = uicontrol('Style', 'checkbox', ...
                                        'Parent', obj.hExternalPanel, ...
                                        'FontSize', 9, ...
                                        'FontName', 'Courier New',...
                                        'Units', 'Normalized', ...
                                        'Position',[0.57 0.96 0.1 0.03],...
                                        'String', 'W. Colour?',...
                                        'Value', 0,...
                                        'Enable','off',...
                                        'Callback', @(source, event)(obj.changeShowChannelWithColour(source)));


            % Popup: Filter Selection
            obj.hInterpolationSelectText = obj.createTextElement([0.71 0.96 0.25 0.03], 'Interpolation for upsample:', 10, false, 'white', obj.hExternalPanel, 'FontName', 'helvetica');


            obj.hInterpolationSelect = uicontrol('Style', 'popupmenu', ...
                                        'Parent', obj.hExternalPanel, ...
                                        'FontSize', 11, ...
                                        'FontName', 'Courier New',...
                                        'Units', 'Normalized', ...
                                        'Position',[0.71 0.93 0.25 0.03],...
                                        'String', {'Nearest neighbour' 'Bilinear' 'Bicubic'},...
                                        'Visible', 'off', ...
                                        'Callback', @(source, event)(obj.changeInterpolationMode(source)));

            % selected block panel
            obj.hSelectedBlockPanel = uipanel('Title', 'Subsampled chroma for selected block (click on image to select):', ...
                                        'Parent', obj.hExternalPanel, ...
                                        'FontSize', 10,  ...
                                        'FontName', 'Courier', ...
                                        'BackgroundColor', 'white', ...
                                        'Units', 'Normalized', ...
                                        'Visible', 'off', ...
                                        'Position', [.01 .01 .98 .29]);
           
            for i=1:3
                % Text elements showing pixel counts
                obj.hSubsampledImagePixelCount{i} = uicontrol('Parent', obj.hExternalPanel, ...
                                        'Style', 'text', ...
                                        'String', 'Number of Pixels: ', ...
                                        'Units', 'Normalized', ...
                                        'HorizontalAlignment', 'center', ...
                                        'Position', [((0.33*(i-1))+0.01) 0.88 0.32 0.03], ...
                                        'Fontsize', 13, ...
                                        'FontName', 'helvetica',...
                                        'BackgroundColor', [0.8 0.8 0.8]);

                obj.hSubsampledImageAxes{i} = obj.createAxesForImage([((0.33*(i-1))+.01) .38 .32 .5], obj.hExternalPanel);

                obj.createTextElement([((0.33*(i-1))+0.01) 0.33 0.2 0.03], 'Subsampling Mode:', 10);
                obj.hSubsampleModeSelect{i} = uicontrol('Style', 'popupmenu', ...
                                        'Parent', obj.hExternalPanel, ...
                                        'FontSize', 10, ...
                                        'FontName', 'Courier New',...
                                        'Units', 'Normalized', ...
                                        'Position',[((0.33*(i-1))+0.01) 0.3 0.14 0.03],...
                                        'Value', obj.defaultSubsamplingMode(i), ...
                                        'String', obj.subsamplingModes(),...
                                        'Callback', @(source, event)(obj.changeSubsamplingModeForImage(source)));
                obj.hShowChannelUpsampledCheckBox{i} = uicontrol('Style', 'checkbox', ...
                                        'Parent', obj.hExternalPanel, ...
                                        'FontSize', 9, ...
                                        'FontName', 'Courier New',...
                                        'Units', 'Normalized', ...
                                        'Position',[((0.33*(i-1))+0.2) 0.3 0.15 0.03],...
                                        'String', 'Show upsampled?',...
                                        'Value', 1,...
                                        'Enable','off',...
                                        'Callback', @(source, event)(obj.toggleShowImageWithUpsampling(source)));

                % Subsampling mode images

                arrayfun(@(c, text)(...
                        obj.createTextElement([((0.33*(i-1))+(.01+(floor(c/3)*.16))) (.39+(rem(c+1,2)*.5)) .16 .1], text, 11, true, 'white', obj.hSelectedBlockPanel) ...
                    ), 1:4, { 'cb' 'block' 'cr' 'samples'},'UniformOutput', false);

                obj.hSubsamplingModeImageAxes{i} = arrayfun(@(c)(...
                                    obj.createAxesForImage([((0.33*(i-1))+(.01+(floor(c/3)*.16))) (.02+(rem(c+1,2)*.48)) .16 .38], obj.hSelectedBlockPanel) ...
                                    ), 1:4,'UniformOutput', false);

                % update combos
                obj.changeSubsamplingModeForImage(obj.hSubsampleModeSelect{i});
            end

            linkaxes(cell2mat(obj.hSubsampledImageAxes), 'xy');

            obj.changeInput(obj.hInputImageSelect);

            if exist('fileName', 'var')
                % Load from file
                files = get(obj.hInputImageSelect, 'String');
                index = strmatch(fileName, files);
                set(obj.hInputImageSelect, 'Value', index);
            end

            modes = strrep(obj.subsamplingModes(), ':', '');
            obj.subsamplingModeImages = cellfun(@(mode)(imread(['+GUIs/images/samplingmodes/' mode '.png'])) , modes, 'UniformOutput', false);

            % Give keyboard focus to image select element
            uicontrol(obj.hInputImageSelect);
        end

        function changeScreenMode(obj, source)

            obj.changeScreenMode@GUIs.base(source);

            if strcmp(get(source, 'State'), 'on')
                % on
                set(obj.hInterpolationSelect, 'Visible', 'on');
                set(obj.hInterpolationSelectText, 'Visible', 'on');
                set(obj.hSelectedBlockPanel, 'Visible', 'on');
            else
                % off
                set(obj.hInterpolationSelect, 'Visible', 'off');
                set(obj.hInterpolationSelectText, 'Visible', 'off');
                set(obj.hSelectedBlockPanel, 'Visible', 'off');
            end
            
        end
       
       function imageClick(obj, source)
           % handle input / output image clicks
            if ~isempty(obj.inputMatrix)
                
                % TODO: urg for loops

                for i=1:length(obj.hShownImage)
                    if source == obj.hShownImage{i}
                        selectedPoint = get(obj.hSubsampledImageAxes{i}, 'CurrentPoint');
                        obj.lastClickedBlockX = (floor((selectedPoint(1,1)-1) / 4)*4) + 1;
                        obj.lastClickedBlockY = (floor((selectedPoint(1,2)-1) / 2)*2) + 1;
                        break;
                    end
                end
                
                if isempty(obj.hSelectedBlockRectangle)
                    obj.hSelectedBlockRectangle = cell(1,3);
                end
                for i=1:3
                    if obj.hSelectedBlockRectangle{i}
                        delete(obj.hSelectedBlockRectangle{i})
                    end
                    obj.hSelectedBlockRectangle{i} = rectangle('Parent', obj.hSubsampledImageAxes{i}, ...
                                                                'Position', [obj.lastClickedBlockX-0.5  obj.lastClickedBlockY-0.5 4 2], ...
                                                                'EdgeColor', [0 0 0], 'LineWidth', 1);
                end
                obj.updateSubsampleViews();
            end               
       end
       
       function updateSubsampleViews(obj)
            for i=1:length(obj.hShownImage)
                if ~isempty(obj.lastClickedBlockX) && ~isempty(obj.lastClickedBlockY)
                    idx = find(ismember(obj.subsamplingModes(), obj.imageStruct{i}.mode)==1);
                    imshow(obj.subsamplingModeImages{idx(1)}, 'Parent', obj.hSubsamplingModeImageAxes{i}{4});

                    Subsampling.subsampledImageShow(obj.imageStruct{i}, 'Parent', obj.hSubsamplingModeImageAxes{i}{1}, ...
                                                    'Channel', 'cb',  'Block', [obj.lastClickedBlockX obj.lastClickedBlockY 4 2], ...
                                                    'Interpolation', obj.interpolationMode, 'ColourDisplay', obj.showChannelInColour);
                    Subsampling.subsampledImageShow(obj.imageStruct{i}, 'Parent', obj.hSubsamplingModeImageAxes{i}{3}, ...
                                                    'Channel', 'cr', 'Block', [obj.lastClickedBlockX obj.lastClickedBlockY 4 2], ...
                                                    'Interpolation', obj.interpolationMode, 'ColourDisplay', obj.showChannelInColour);
                    Subsampling.subsampledImageShow(obj.imageStruct{i}, 'Parent', obj.hSubsamplingModeImageAxes{i}{2}, ...
                                                    'Channel', 'all', 'Block', [obj.lastClickedBlockX obj.lastClickedBlockY 4 2], ...
                                                    'Interpolation', obj.interpolationMode, 'ColourDisplay', obj.showChannelInColour);
                end
            end
       end
       
       function modes = subsamplingModes(obj)
           modes = {'4:4:4' '4:4:0' '4:2:2' '4:2:0' '4:1:1' '4:1:0'};
       end
       
       function changeSubsamplingModeForImage(obj, source)
           for i=1:length(obj.hSubsampleModeSelect)
               if source == obj.hSubsampleModeSelect{i}
                    strings = get(source, 'String');
                    obj.subsamplingMode{i} = strings{get(source, 'Value')};
                    break;
               end
           end
           obj.doSubsamplingOnImageMatrix();
           obj.updateAxes(true);
        end

        function changeInput(obj, source)
            % Call super class implementation which does the loading etc
            obj.changeInput@GUIs.base(source);
            obj.hSelectedBlockRectangle = cell(1,3);
            obj.lastClickedBlockX = [];
            obj.lastClickedBlockY = [];
            obj.doSubsamplingOnImageMatrix();
            obj.updateAxes();
        end

        function changeChannelOnDisplay(obj, source)
            selected = get(source, 'Value');
            switch(selected)
                case 1
                    obj.channelToShow = 'all';
                case 2
                    obj.channelToShow = 'y';
                case 3
                    obj.channelToShow = 'cb';
                case 4
                    obj.channelToShow = 'cr';
            end

            obj.updateCheckBoxStatus();

            obj.updateAxes(true);
        end

        function changeShowChannelWithColour(obj, source)
            obj.showChannelInColour = get(source, 'Value');
            obj.updateAxes(true);
        end
       
        function toggleShowImageWithUpsampling(obj, source)
            for i=1:length(obj.hShowChannelUpsampledCheckBox)
                if source == obj.hShowChannelUpsampledCheckBox{i}
                    obj.upsampleImage{i} = get(obj.hShowChannelUpsampledCheckBox{i}, 'Value');
                    obj.updateAxes();
                    break;
                end
            end
        end
       
        function updateCheckBoxStatus(obj)
            if strcmp(obj.channelToShow, 'all')
                % disable
                enabled = 'off';
            else
                % enable
                enabled = 'on';
            end

            set(obj.hShowChannelInColours, 'Enable', enabled);

            for i=1:length(obj.hShowChannelUpsampledCheckBox)
                set(obj.hShowChannelUpsampledCheckBox{i}, 'Enable', enabled);
            end
        end
       
        function changeInterpolationMode(obj, source)
            switch get(source, 'Value')
                case 1
                    obj.interpolationMode = 'nearest';
                case 2
                    obj.interpolationMode = 'bilinear';
                case 3
                    obj.interpolationMode = 'bicubic';
            end
           
            obj.updateAxes(true);
        end
       
       function doSubsamplingOnImageMatrix(obj)
            if ~isempty(obj.inputMatrix)
                for i=1:length(obj.subsamplingMode)
                    obj.imageStruct{i} = Subsampling.ycbcrImageToSubsampled(obj.inputMatrix, 'Mode', obj.subsamplingMode{i});
                end
            end
       end

        function updatePixelCounts(obj)
            for i=1:length(obj.imageStruct)
                %[ yHi yVi cbHi cbVi crHi crVi ] = Subsampling.modeToHorizontalAndVerticalSamplingFactors(obj.imageStruct{i}.mode);
                pixelcount = numel(obj.imageStruct{i}.y) + numel(obj.imageStruct{i}.cb) + numel(obj.imageStruct{i}.cr);
                set(obj.hSubsampledImagePixelCount{i}, 'String', ['Number of Pixels: ' num2str(pixelcount)]);
            end
        end

        function updateAxes(obj, saveZoomState)
            if ~exist('saveZoomState', 'var');
                saveZoomState = false;
            end
            if ~isempty(obj.inputMatrix)
                for i=1:length(obj.imageStruct)
                    % save zoom state
                    if saveZoomState
                        currentLimsX = get(obj.hSubsampledImageAxes{i},'XLim');
                        currentLimsY = get(obj.hSubsampledImageAxes{i},'YLim');
                    end
                    if obj.upsampleImage{i}
                        obj.hShownImage{i} = Subsampling.subsampledImageShow(obj.imageStruct{i}, 'Parent', obj.hSubsampledImageAxes{i}, ...
                            'Channel', obj.channelToShow, 'Interpolation', obj.interpolationMode, 'ColourDisplay', obj.showChannelInColour);
                    else
                        obj.hShownImage{i} = Subsampling.subsampledImageShow(obj.imageStruct{i}, 'Parent', obj.hSubsampledImageAxes{i}, ...
                            'Channel', obj.channelToShow, 'ColourDisplay', obj.showChannelInColour, 'Upsample', false);
                    end
                    %reapply zoom lims
                    if saveZoomState
                        set(obj.hSubsampledImageAxes{i}, 'XLim', currentLimsX);
                        set(obj.hSubsampledImageAxes{i}, 'YLim', currentLimsY);
                    end
                    set(obj.hShownImage{i}, 'ButtonDownFcn', @(source, evt)(obj.imageClick(source)));
                end
                obj.updatePixelCounts();
                obj.updateSubsampleViews();
            end
           
            obj.hSelectedBlockRectangle = cell(1,3);
        end
   end
end 
