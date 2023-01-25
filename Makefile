build-and-push:
	docker buildx build \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from ${IMAGE_NAME}:latest \
		--platform ${PLATFORMS} \
		--target ${TARGET} \
		--push \
		--tag ${IMAGE_NAME}:${TAG} \
		${EXTRA_ARGS} \
		.