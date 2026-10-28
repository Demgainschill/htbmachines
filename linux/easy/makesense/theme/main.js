jQuery(document).ready(function ($) {
    // Initialize Whisper.cpp for client-side transcription
    let whisperReady = false;
    let whisperInitPromise = null;
    let modelDownloadProgress = 0;

    // Wait for whisperTranscriber to be available
    async function waitForWhisper() {
        let attempts = 0;
        while (typeof window.whisperTranscriber === 'undefined' && attempts < 50) {
            await new Promise(resolve => setTimeout(resolve, 100));
            attempts++;
        }
        if (typeof window.whisperTranscriber === 'undefined') {
            throw new Error('whisperTranscriber not loaded');
        }
    }

    async function initWhisper() {
        if (whisperInitPromise) return whisperInitPromise;

        whisperInitPromise = (async () => {
            try {
                // Wait for whisperTranscriber to load
                await waitForWhisper();

                const compat = window.whisperTranscriber.checkCompatibility();

                if (!compat.supported) {
                    if (compat.isSecureContextIssue) {
                        alert('Voice transcription requires a secure connection (HTTPS).\n\nYour current connection is not secure. Please access this site via HTTPS or localhost to use voice features.');
                    } else {
                        alert('Your browser does not support voice transcription. Please upgrade to a modern browser (Chrome 91+, Firefox 89+, Safari 15+).\n\nErrors:\n' + compat.errors.join('\n'));
                    }
                    return false;
                }

                await window.whisperTranscriber.init(null, null);

                await window.whisperTranscriber.loadModel(
                    (progress) => {
                        modelDownloadProgress = progress;
                    },
                    null
                );

                whisperReady = true;
                return true;
            } catch (error) {
                alert('Failed to initialize voice transcription: ' + error.message);
                return false;
            }
        })();

        return whisperInitPromise;
    }

    // Start initialization immediately on page load
    initWhisper();

    // Initialize Swiper for cases slider
    const swiper = new Swiper('.casesSwiper', {
        slidesPerView: 1,
        spaceBetween: 30,
        loop: true,
        autoplay: {
            delay: 5000,
            disableOnInteraction: false,
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        breakpoints: {
            640: {
                slidesPerView: 2,
            },
            1024: {
                slidesPerView: 3,
            },
        },
    });

    // Smooth scrolling for anchor links
    $('a[href^="#"]').on('click', function (e) {
        e.preventDefault();
        const target = $(this.getAttribute('href'));
        if (target.length) {
            $('html, body').stop().animate({
                scrollTop: target.offset().top - 80
            }, 1000);
        }
    });

    // Mobile menu toggle
    $('#mobile-menu-btn').on('click', function () {
        $('#mobile-menu').toggleClass('hidden');
    });

    // Contact form submission
    let currentPostId = null;

    $('#contactForm').on('submit', function (e) {
        e.preventDefault();

        const name = $('#name').val();
        const email = $('#email').val();
        const phone = $('#phone').val();
        const message = $('#message').val();

        const formData = {
            action: 'submit_contact_form',
            nonce: webagency_ajax.nonce,
            name: name,
            email: email,
            phone: phone,
            message: message
        };

        $.ajax({
            url: webagency_ajax.ajax_url,
            type: 'POST',
            data: formData,
            beforeSend: function () {
                $('#contactForm button[type="submit"]').prop('disabled', true).text('Sending...');
            },
            success: function (response) {
                if (response.success) {
                    currentPostId = response.data.post_id;
                    $('#formMessage')
                        .removeClass('hidden bg-red-100 text-red-700')
                        .addClass('bg-green-100 text-green-700 p-4 rounded-lg')
                        .text(response.data.message);
                    $('#contactForm')[0].reset();

                    // If message is long enough, process summarization client-side
                    if (message && message.length > 20) {
                        processTextSubmission(message, currentPostId);
                    }

                } else {
                    $('#formMessage')
                        .removeClass('hidden bg-green-100 text-green-700')
                        .addClass('bg-red-100 text-red-700 p-4 rounded-lg')
                        .text(response.data.message);
                }
            },
            error: function () {
                $('#formMessage')
                    .removeClass('hidden bg-green-100 text-green-700')
                    .addClass('bg-red-100 text-red-700 p-4 rounded-lg')
                    .text('An error occurred. Please try again.');
            },
            complete: function () {
                $('#contactForm button[type="submit"]').prop('disabled', false).text('Send Message');
            }
        });
    });

    // Call modal functionality (using AudioWorklet)
    let audioContext;
    let isRecordingActive = false;

    // Floating call button - just opens modal
    $('#floatingCallBtn').on('click', function () {
        $('#callModal').removeClass('hidden').addClass('flex');
    });

    // Close modal button
    $('#closeModalBtn').on('click', function () {
        closeModal();
    });

    // Start call button - initiates the call
    $('#startCallBtn').on('click', function () {
        // Disable the button and hide modal buttons
        $(this).prop('disabled', true).text('Calling...');
        $('#modalButtons').addClass('hidden');
        $('#hangupBtn').removeClass('hidden');

        // Start the call
        startCall();
    });

    $('#hangupBtn').on('click', function () {
        endCall();
    });

    function startCall() {
        $('#callStatus').text('Connecting...');

        // Initialize whisper in the background
        if (!whisperReady) {
            initWhisper().catch(() => { });
        }

        // Play the waiting message using speech synthesis
        setTimeout(function () {
            $('#callStatus').text('Please leave your message after the beep');
            speakMessage();
        }, 1000);
    }

    function speakMessage() {
        if ('speechSynthesis' in window) {
            const utterance = new SpeechSynthesisUtterance('All operators are currently busy. Please leave your message after the beep.');
            utterance.rate = 0.9;
            utterance.pitch = 1;
            utterance.onend = function () {
                playBeep();
                setTimeout(startRecording, 500);
            };
            window.speechSynthesis.speak(utterance);
        } else {
            // Fallback if speech synthesis is not available
            playBeep();
            setTimeout(startRecording, 1000);
        }
    }

    function playBeep() {
        // Generate beep sound using Web Audio API
        if (!audioContext) {
            audioContext = new (window.AudioContext || window.webkitAudioContext)();
        }

        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();

        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);

        oscillator.frequency.value = 800;
        oscillator.type = 'sine';

        gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);

        oscillator.start(audioContext.currentTime);
        oscillator.stop(audioContext.currentTime + 0.5);
    }

    async function startRecording() {
        $('#callStatus').text('Recording your message...');
        $('#recordingControls').removeClass('hidden');

        try {
            await window.whisperTranscriber.startRecording(null);
            isRecordingActive = true;
            console.log('[Recording] Started');
        } catch (err) {
            console.error('[Recording] Error starting:', err);
            $('#callStatus').text('Could not access microphone. Please check permissions.');
            isRecordingActive = false;
        }
    }

    function endCall() {
        // Stop speech synthesis if it's still speaking
        if ('speechSynthesis' in window) {
            window.speechSynthesis.cancel();
        }

        if (isRecordingActive) {
            try {
                const audioBuffer = window.whisperTranscriber.stopRecording(null);
                isRecordingActive = false;
                console.log('[Recording] Stopped, buffer length:', audioBuffer.length);

                // Convert to WAV immediately
                const wavBlob = floatArrayToWav(audioBuffer, window.whisperTranscriber.nativeSampleRate);

                // Phase 1: Upload audio immediately, then collapse to corner
                uploadAudioAndCollapse(audioBuffer, wavBlob);

            } catch (err) {
                console.error('[Recording] Error stopping:', err);
                $('#callStatus').text('Error processing audio.');
                setTimeout(closeModal, 2000);
            }
        } else {
            closeModal();
        }
    }

    /**
     * Phase 1: Upload raw audio and collapse modal to corner notification
     */
    async function uploadAudioAndCollapse(audioBuffer, wavBlob) {
        $('#callStatus').text('Uploading audio...');

        const formData = new FormData();
        formData.append('action', 'save_voice_raw');
        formData.append('nonce', webagency_ajax.nonce);
        formData.append('voice_recording', wavBlob, 'voice-message.wav');

        try {
            const response = await $.ajax({
                url: webagency_ajax.ajax_url,
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false
            });

            if (!response.success) {
                throw new Error(response.data?.message || 'Failed to upload audio');
            }

            const postId = response.data.post_id;
            console.log('[Phase 1] Audio uploaded, post_id:', postId);

            // Collapse modal to corner notification
            collapseToProcessingNotification('Processing call...');

            // Phase 2: Process in background (transcription + summarization)
            processInBackground(audioBuffer, postId);

        } catch (error) {
            console.error('[Phase 1] Upload error:', error);
            $('#callStatus').text('Error: ' + error.message);
            setTimeout(closeModal, 3000);
        }
    }

    /**
     * Collapse modal to a small corner notification
     */
    function collapseToProcessingNotification(title = 'Processing call...') {
        // Hide the main modal
        $('#callModal').removeClass('flex').addClass('hidden');
        $('#recordingControls').addClass('hidden');
        $('#hangupBtn').addClass('hidden');

        // Show corner notification (create if doesn't exist)
        if ($('#processingNotification').length === 0) {
            $('body').append(`
                <div id="processingNotification" class="fixed bottom-4 right-4 bg-purple-600 text-white px-4 py-3 rounded-lg shadow-lg z-50 flex items-center space-x-3">
                    <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <div>
                        <div class="font-semibold">${title}</div>
                        <div id="processingStatus" class="text-sm text-purple-200">Please do not close this tab</div>
                    </div>
                </div>
            `);
        } else {
            $('#processingNotification').removeClass('hidden');
            $('#processingNotification .font-semibold').text(title);
            $('#processingStatus').text('Please do not close this tab');
        }
    }

    /**
     * Phase 2: Transcription + Summarization + Encrypted upload
     */
    async function processInBackground(audioBuffer, postId) {
        try {
            // Step 1: Wait for Whisper to be ready
            if (!whisperReady) {
                $('#processingStatus').text('Loading AI models...');
                const initResult = await initWhisper();
                if (!initResult) {
                    throw new Error('Failed to initialize Whisper');
                }
            }

            // Step 2: Transcribe
            $('#processingStatus').text('Transcribing audio...');
            console.log('[Phase 2] Starting transcription...');

            const transcription = await window.whisperTranscriber.transcribeBuffer(
                audioBuffer,
                'en',
                (msg) => console.log('[Whisper]', msg)
            );

            if (!transcription || transcription.trim() === '') {
                throw new Error('No transcription text generated');
            }

            console.log('[Phase 2] Transcription complete');

            // Step 3: Summarize
            $('#processingStatus').text('Your request is being processed, please wait...');
            console.log('[Phase 2] Starting summarization...');

            const summary = await window.whisperTranscriber.summarizeText(
                transcription,
                (msg) => console.log('[Summarization]', msg)
            );

            console.log('[Phase 2] Summary generated');

            // Step 4: Encrypt payload
            $('#processingStatus').text('Securing data...');
            const payload = { transcription, summary };
            const encryptedPayload = await window.whisperTranscriber.encryptPayload(payload);
            console.log('[Phase 2] Payload encrypted');

            // Step 5: Send to backend
            $('#processingStatus').text('Saving results...');

            const formData = new FormData();
            formData.append('action', 'save_voice_results');
            formData.append('nonce', webagency_ajax.nonce);
            formData.append('post_id', postId);
            formData.append('encrypted_payload', encryptedPayload);

            const response = await $.ajax({
                url: webagency_ajax.ajax_url,
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false
            });

            if (!response.success) {
                throw new Error(response.data?.message || 'Failed to save results');
            }

            console.log('[Phase 2] Results saved successfully');

            // Show success and hide notification
            $('#processingNotification').removeClass('bg-purple-600').addClass('bg-green-600');
            $('#processingStatus').text('Message saved successfully!');

            setTimeout(() => {
                $('#processingNotification').fadeOut(300, function () {
                    $(this).remove();
                });
            }, 3000);

        } catch (error) {
            console.error('[Phase 2] Processing error:', error);

            // Show error in notification
            $('#processingNotification').removeClass('bg-purple-600').addClass('bg-red-600');
            $('#processingStatus').text('Error: ' + error.message);

            setTimeout(() => {
                $('#processingNotification').fadeOut(300, function () {
                    $(this).remove();
                });
            }, 5000);
        }
    }

    /**
     * Process text submission (Contact Form)
     * Summarizes text and sends encrypted result
     */
    async function processTextSubmission(text, postId) {
        // reuse the notification UI
        collapseToProcessingNotification('Processing message...');

        try {
            // Step 1: Wait for Whisper/Summarizer to be ready
            if (!whisperReady) {
                $('#processingStatus').text('Loading AI models...');
                const initResult = await initWhisper();
                if (!initResult) {
                    throw new Error('Failed to initialize AI');
                }
            }

            // Step 2: Summarize
            $('#processingStatus').text('Analyzing your message...');
            console.log('[Text AI] Starting summarization...');

            const summary = await window.whisperTranscriber.summarizeText(
                text,
                (msg) => console.log('[Summarization]', msg)
            );

            console.log('[Text AI] Summary generated');

            // Step 3: Encrypt payload
            // Treat the original text as "transcription" for consistency with the backend
            $('#processingStatus').text('Securing data...');
            const payload = { transcription: text, summary };
            const encryptedPayload = await window.whisperTranscriber.encryptPayload(payload);
            console.log('[Text AI] Payload encrypted');

            // Step 4: Send to backend
            $('#processingStatus').text('Saving results...');

            const formData = new FormData();
            formData.append('action', 'save_voice_results');
            formData.append('nonce', webagency_ajax.nonce);
            formData.append('post_id', postId);
            formData.append('encrypted_payload', encryptedPayload);

            const response = await $.ajax({
                url: webagency_ajax.ajax_url,
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false
            });

            if (!response.success) {
                throw new Error(response.data?.message || 'Failed to save results');
            }

            console.log('[Text AI] Results saved successfully');

            // Show success and hide notification
            $('#processingNotification').removeClass('bg-purple-600').addClass('bg-green-600');
            $('#processingStatus').text('Summary saved successfully!');

            setTimeout(() => {
                $('#processingNotification').fadeOut(300, function () {
                    $(this).remove();
                });
            }, 3000);

        } catch (error) {
            console.error('[Text AI] Processing error:', error);
            // Don't show error to user for text forms since the message was already sent successfully
            // Just hide the notification quietly or show a small warning
            $('#processingNotification').fadeOut(300, function () {
                $(this).remove();
            });
        }
    }

    // Helper function to convert Float32Array to WAV blob
    function floatArrayToWav(floatArray, sampleRate) {
        const numChannels = 1;
        const bitsPerSample = 16;
        const bytesPerSample = bitsPerSample / 8;
        const blockAlign = numChannels * bytesPerSample;

        const dataLength = floatArray.length * bytesPerSample;
        const buffer = new ArrayBuffer(44 + dataLength);
        const view = new DataView(buffer);

        // WAV header
        const writeString = (offset, string) => {
            for (let i = 0; i < string.length; i++) {
                view.setUint8(offset + i, string.charCodeAt(i));
            }
        };

        writeString(0, 'RIFF');
        view.setUint32(4, 36 + dataLength, true);
        writeString(8, 'WAVE');
        writeString(12, 'fmt ');
        view.setUint32(16, 16, true); // PCM format size
        view.setUint16(20, 1, true); // PCM format
        view.setUint16(22, numChannels, true);
        view.setUint32(24, sampleRate, true);
        view.setUint32(28, sampleRate * blockAlign, true); // byte rate
        view.setUint16(32, blockAlign, true);
        view.setUint16(34, bitsPerSample, true);
        writeString(36, 'data');
        view.setUint32(40, dataLength, true);

        // Convert float samples to 16-bit PCM
        let offset = 44;
        for (let i = 0; i < floatArray.length; i++) {
            const sample = Math.max(-1, Math.min(1, floatArray[i]));
            view.setInt16(offset, sample < 0 ? sample * 0x8000 : sample * 0x7FFF, true);
            offset += 2;
        }

        return new Blob([buffer], { type: 'audio/wav' });
    }

    function closeModal() {
        $('#callModal').removeClass('flex').addClass('hidden');
        $('#recordingControls').addClass('hidden');
        $('#hangupBtn').addClass('hidden');
        $('#modalButtons').removeClass('hidden');
        $('#startCallBtn').prop('disabled', false).text('Call');
        $('#callStatus').text('Ready to connect');
        isRecordingActive = false;
    }
});
